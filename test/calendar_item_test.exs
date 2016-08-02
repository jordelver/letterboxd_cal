defmodule LetterboxdCal.Calendar.Item.Test do
  use ExUnit.Case
  doctest LetterboxdCal.Calendar.Item

  alias LetterboxdCal.Calendar.Item

  setup_all do
    movie = %{release_date: "2016-08-02"}
    {:ok, movie: movie}
  end

  test "dtstamp returns a date with local time", state do
    assert Item.dtstamp(state[:movie]) == "20160802T000000Z"
  end

  test "dtstart returns a short date", state do
    assert Item.dtstart(state[:movie]) == "20160802"
  end

  test "dtend returns a short date", state do
    assert Item.dtend(state[:movie]) == "20160802"
  end
end

