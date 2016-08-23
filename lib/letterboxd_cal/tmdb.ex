defmodule LetterboxdCal.TMDB do
  @moduledoc """
  Retrieves movie information for a given movie using data from TMDB
  """

  alias LetterboxdCal.TMDB.{MovieID, MovieReleaseDate}

  def release_date(movie = %{}) do
    release_date(movie.title, movie.year)
  end

  def release_date(title, year) do
    MovieID.movie_id(title, year) |> MovieReleaseDate.movie_release_date
  end
end

