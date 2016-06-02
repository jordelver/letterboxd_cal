defmodule LetterboxdCal.Watchlist do
  use Hound.Helpers

  def movies do
    Hound.start_session

    navigate_to(watchlist_url)

    wait_for_page_load

    page_source
      |> Floki.parse()
      |> Floki.find(".poster-container .frame-title")
      |> Enum.map(&Floki.text/1)
      |> Enum.map(&extract_movie_info/1)
  end

  # It's possible that this is just setting us
  # up for trouble as the page may take longer
  # than 4 seconds to load which would mean we
  # return an empty set
  defp wait_for_page_load do
    :timer.sleep(4000)
  end

  # Do this when getting the release info from
  # IMDB, not here. Store the whole string in
  # the database
  defp extract_movie_info(title) do
    title
    |> String.replace(")", "")
    |> String.split(~r{ \(})
  end

  defp watchlist_url do
    "http://letterboxd.com/#{watchlist_username}/watchlist/"
  end

  defp watchlist_username do
    Application.get_env(:letterboxd_cal, :letterboxd_username)
  end
end

