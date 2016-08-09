defmodule LetterboxdCal.Calendar.Item do
  @moduledoc """
  Represents a calendar item

  ## Examples

  iex> movie = %{release_date: "2016-08-02"}
  ...> LetterboxdCal.Calendar.Item.dtstamp(movie)
  "20160802T000000Z"

  iex> movie = %{release_date: "2016-08-02"}
  ...> LetterboxdCal.Calendar.Item.dtstart(movie)
  "20160802"

  iex> movie = %{release_date: "2016-08-02"}
  ...> LetterboxdCal.Calendar.Item.dtend(movie)
  "20160802"

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
    format_date(datetime, "%Y%m%dT000000Z")
  end

  defp date(datetime) do
    format_date(datetime, "%Y%m%d")
  end

  defp format_date(datetime, format) do
    {_, datetime} = datetime |> Timex.parse("{YYYY}-{M}-{D}")

    datetime
    |> Timex.format(format, :strftime)
    |> elem(1)
  end
end

