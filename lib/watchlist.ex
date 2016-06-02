defmodule LetterboxdCal.Watchlist do
  use Hound.Helpers

  def movies do
    Hound.start_session

    parse_page(1, [])
  end

  defp parse_page(nil, movies), do: movies
  defp parse_page(page_number, movies) do
    navigate_to(watchlist_url(page_number))
    wait_for_page_load
    parse_page(next_page, movies ++ results)
  end

  defp results do
    page_source
    |> Floki.parse()
    |> Floki.find(".poster-container .frame-title")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&extract_movie_info/1)
  end

  defp next_page do
    next_page_link |> next_page_number
  end

  defp next_page_number([]), do: nil
  defp next_page_number(next_link) do
    next_link
    |> List.first
    |> String.split("/", trim: true)
    |> List.last
    |> String.to_integer
  end

  defp next_page_link do
    page_source
    |> Floki.parse()
    |> Floki.find(".paginate-next")
    |> Floki.attribute("href")
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

  defp watchlist_url(page_number) do
    "https://letterboxd.com/#{watchlist_username}/watchlist/page/#{page_number}/"
  end

  defp watchlist_username do
    Application.get_env(:letterboxd_cal, :letterboxd_username)
  end
end

