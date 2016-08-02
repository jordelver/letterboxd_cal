defmodule LetterboxdCal.Calendar.Item do
  @moduledoc """
  Represents a calendar item
  """
  defstruct title: nil, dtstamp: nil, dtstart: nil, dtend: nil

  def dtstamp(movie) do
    date_with_local_time(movie.release_date)
  end

  def dtstart(movie) do
    date(movie.release_date)
  end

  def dtend(movie) do
    date(movie.release_date)
  end

  defp date_with_local_time(datetime) do
    {_, datetime} = datetime |> Timex.parse("{YYYY}-{M}-{D}")

    datetime
    |> Timex.format("%Y%m%dT000000Z", :strftime)
    |> elem(1)
  end

  defp date(datetime) do
    {_, datetime} = datetime |> Timex.parse("{YYYY}-{M}-{D}")

    datetime
    |> Timex.format("%Y%m%d", :strftime)
    |> elem(1)
  end
end

