defmodule LetterboxdCal.Watchlist do
  require Logger

  def movies do
    parse_page(1, [])
  end

  defp parse_page(:empty, movies), do: movies
  defp parse_page(page_number, movies) do
    Logger.debug("Parsing page: #{watchlist_page_url(page_number)}")

    page = page_source(page_number)
    results =  page |> watchlist_movies
    parse_page(next_page(page), movies ++ results)
  end

  def page_source(page_number) do
    case HTTPoison.get(watchlist_page_url(page_number)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body |> Floki.parse()
    end
  end

  def watchlist_movies(page_source) do
    page_source
    |> extract_movie_titles
    |> Enum.map(&extract_movie_info/1)
  end

  def extract_movie_titles(page_source) do
    page_source
    |> Floki.find(".poster")
    |> Floki.attribute("data-film-slug")
  end

  defp next_page(page_source) do
    page_source
    |> next_page_link
    |> next_page_number
  end

  defp next_page_number([]), do: :empty
  defp next_page_number(next_link) do
    next_link
    |> List.first
    |> String.split("/", trim: true)
    |> List.last
    |> String.to_integer
  end

  defp next_page_link(page_source) do
    page_source
    |> Floki.find(".paginate-next")
    |> Floki.attribute("href")
  end

  defp extract_movie_info(slug) do
    case HTTPoison.get(watchlist_film_slug_url(slug)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

        title = film_title(body)
        year  = film_release_year(body)

        %{original_title: "#{title} (#{year})", title: title, year: year}
    end
  end

  def film_title(page_source) do
    page_source
    |> Floki.attribute("data-film-name")
    |> Floki.text
  end

  def film_release_year(page_source) do
    page_source
    |> Floki.attribute("data-film-release-year")
    |> Floki.text
  end

  defp watchlist_page_url(page_number) do
    "https://letterboxd.com/#{watchlist_username}/watchlist/page/#{page_number}/"
  end

  def watchlist_film_slug_url(slug) do
    "https://letterboxd.com/ajax/poster#{slug}menu/linked/125x187/"
  end

  defp watchlist_username do
    Application.get_env(:letterboxd_cal, :letterboxd_username)
  end
end

