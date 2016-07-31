defmodule LetterboxdCal.Calendar do
  @moduledoc """
  Outputs an iCal calendar feed of movies from the database
  """

  defmodule Item do
    @moduledoc """
    Represents a calendar item
    """
    defstruct title: nil, dtstamp: nil, dtstart: nil, dtend: nil

    def dtstamp(movie) do
      long_date(movie.release_date)
    end

    def dtstart(movie) do
      short_date(movie.release_date)
    end

    def dtend(movie) do
      short_date(movie.release_date)
    end

    # TODO Rename to a sensible name
    # What sort of date is this?
    defp long_date(datetime) do
      {_, datetime} = datetime |> Timex.parse("{YYYY}-{M}-{D}")

      datetime
      |> Timex.format("%Y%m%dT000000Z", :strftime)
      |> elem(1)
    end

    defp short_date(datetime) do
      {_, datetime} = datetime |> Timex.parse("{YYYY}-{M}-{D}")

      datetime
      |> Timex.format("%Y%m%d", :strftime)
      |> elem(1)
    end
  end

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

