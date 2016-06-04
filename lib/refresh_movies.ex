defmodule LetterboxdCal.RefreshMovies do
  import Moebius.DocumentQuery

  def refresh do
    Enum.each(movies, &save_movie/1)
  end

  def save_movie(movie) do
    db(:movies) |> LetterboxdCal.Db.save(movie)
  end

  defp movies do
    LetterboxdCal.Watchlist.movies
  end
end

