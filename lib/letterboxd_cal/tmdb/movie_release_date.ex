defmodule LetterboxdCal.TMDB.MovieReleaseDate do
  import LetterboxdCal.TMDB.Helpers

  def movie_release_date(movie_id) do
    case HTTPoison.get(movie_release_date_url(movie_id, params())) do
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

  defp filter_by_country(results, country) do
    results
    |> Enum.find(&match?(%{"iso_3166_1" => ^country}, &1))
  end

  defp get_release_dates(nil), do: []
  defp get_release_dates(results) do
    results
    |> Map.get("release_dates")
    |> Enum.filter(fn(result) -> result["type"] == theatrical_release() end)
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
end

