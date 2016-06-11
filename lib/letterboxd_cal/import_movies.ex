defmodule LetterboxdCal.ImportMovies do
  import Moebius.Query

  def import do
    Enum.each(movies, &save_movie/1)
  end

  def save_movie(movie) do
    db(:movies)
    |> insert(movie |> Map.to_list)
    |> LetterboxdCal.Db.run
  end

  # TODO Move this into whatever calls `ImportMovies` and pipe it in?
  #
  #   LetterboxdCal.Watchlist.movies |> LetterboxdCal.ImportMovies.import
  #
  defp movies do
    LetterboxdCal.Watchlist.movies
  end
end

