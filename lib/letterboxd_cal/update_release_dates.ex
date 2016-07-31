defmodule LetterboxdCal.UpdateReleaseDates do
  @moduledoc """
  Updates each movie release date in the database using data from TMDB
  """

  require Logger
  import Moebius.Query

  alias LetterboxdCal.TMDB

  def update do
    Logger.debug("Updating movie release dates from TMDB")
    Enum.each(future_releases_without_release_date, &update_release_date/1)
  end

  def update_release_date(movie) do
    TMDB.release_date(movie) |> update_movie(movie)
  end

  def update_movie(:empty, _), do: :empty
  def update_movie(release_date, movie) do
    "UPDATE movies SET release_date = '#{format_date(release_date)}' WHERE original_title = '#{movie.original_title}';"
    |> LetterboxdCal.Db.run
  end

  def future_releases_without_release_date do
    db(:movies)
    |> filter("year >= '#{Timex.Date.today.year}'")
    |> filter("release_date IS NULL")
    |> LetterboxdCal.Db.run
  end

  def format_date(date_string) do
    {_, datetime} = Timex.parse(date_string, "%Y-%m-%dT00:00:00.000Z", :strftime)

    {_, date} = datetime
      |> Timex.to_date
      |> Timex.format("%Y-%m-%d", :strftime)

    date
  end
end

