defmodule LetterboxdCal.ImportMovies do
  @moduledoc """
  Imports movies from the Letterboxd Watchlist and saves them to the database
  """

  require Logger
  import Moebius.Query

  def import do
    Logger.debug("Importing new movies from Letterboxd")
    Enum.each(movies, &save_movie/1)
  end

  def save_movie(movie) do
    db(:movies)
    |> insert(movie |> Map.to_list)
    |> LetterboxdCal.Db.run
  end

  defp movies do
    LetterboxdCal.Watchlist.movies
  end
end

