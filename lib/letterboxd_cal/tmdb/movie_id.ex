defmodule LetterboxdCal.TMDB.MovieID do
  import LetterboxdCal.TMDB.Helpers

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

  defp movie_search_url(params) do
    "https://api.themoviedb.org/3/search/movie?"
      <> URI.encode_query(params)
  end

  defp filter_by_title(results, title) do
    results
    |> Enum.filter(&title_matches?(&1, title))
  end

  defp extract_fields(results) do
    fields = ~w(id original_title release_date)

    results
    |> Enum.map(fn(result) -> Map.take(result, fields) end)
  end

  defp get_id(list) do
    list
    |> List.first
    |> Map.get("id")
  end

  defp title_matches?(result, title) do
    result["original_title"] == title
  end
end

