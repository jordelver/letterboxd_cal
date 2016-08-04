defmodule LetterboxdCal.TMDB do
  @moduledoc """
  Retrieves movie information for a given movie using data from TMDB
  """

  def release_date(movie = %{}) do
    release_date(movie.title, movie.year)
  end

  def release_date(title, year) do
    movie_id(title, year) |> movie_release_date
  end

  def movie_id(title, year) do
    query = %{"query" => title, "year" => year}

    case HTTPoison.get(movie_search_url(params(query))) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> get_results
        |> filter_by_title(title)
        |> extract_fields
        |> get_id
    end
  end

  defp extract_fields(results) do
    fields = ~w(id original_title release_date)

    results
    |> Enum.map(fn(result) -> Map.take(result, fields) end)
  end

  defp filter_by_title(results, title) do
    results
    |> Enum.filter(&title_matches?(&1, title))
  end

  defp title_matches?(result, title) do
    result["original_title"] == title
  end

  defp get_id(list) do
    list
    |> List.first
    |> Map.get("id")
  end

  defp get_results(body) do
    body
    |> Poison.decode!
    |> Map.get("results")
  end

  defp filter_by_country(results, country) do
    results
    |> Enum.find(&match?(%{"iso_3166_1" => ^country}, &1))
  end

  def movie_release_date(movie_id) do
    case HTTPoison.get(movie_release_date_url(movie_id, params)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> get_results
        |> filter_by_country("GB")
        |> get_release_dates
        |> get_release_date
      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
        IO.puts "Oh noes"
    end
  end

  defp get_release_dates(nil), do: []
  defp get_release_dates(results) do
    results
    |> Map.get("release_dates")
    |> Enum.filter(fn(result) -> result["type"] == theatrical_release end)
  end

  defp get_release_date([]), do: :empty
  defp get_release_date(results) do
    results
    |> List.first
    |> Map.get("release_date")
  end

  defp theatrical_release, do: 3

  defp movie_release_date_url(movie_id, params) do
    "https://api.themoviedb.org/3/movie/#{movie_id}/release_dates?"
      <> URI.encode_query(params)
  end

  defp movie_search_url(params) do
    "https://api.themoviedb.org/3/search/movie?"
      <> URI.encode_query(params)
  end

  defp params(query \\ %{}) do
    default_params |> Map.merge(query)
  end

  defp default_params do
    %{"api_key" => api_key}
  end

  defp api_key do
    Application.get_env(:letterboxd_cal, :tmdb_api_key)
  end
end

