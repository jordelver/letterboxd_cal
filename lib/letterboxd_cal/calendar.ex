defmodule LetterboxdCal.Calendar do
  @moduledoc """
  Outputs an iCal calendar feed of movies from the database
  """

  alias LetterboxdCal.Calendar.Item
  import Moebius.Query
  require EEx

  EEx.function_from_file(:def, :template,
    "lib/letterboxd_cal/calendar.eex", [:movies], trim: true)

  def ical do
    template(movies)
  end

  def movies do
    Enum.map(movie_release_dates, fn (movie) ->
      %Item{
        title:   movie.title,
        dtstamp: Item.dtstamp(movie),
        dtstart: Item.dtstart(movie),
        dtend:   Item.dtend(movie),
      }
    end)
  end

  def movie_release_dates do
    db(:movies)
    |> filter("release_date >= '#{today}'")
    |> LetterboxdCal.Db.run
  end

  def today do
    Timex.Date.today |> Timex.format("%Y-%m-%d", :strftime) |> elem(1)
  end
end

