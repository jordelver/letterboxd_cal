defmodule LetterboxdCal.TMDB.Helpers do
  def get_results(body) do
    body
    |> Poison.decode!
    |> Map.get("results")
  end

  def params(query \\ %{}) do
    default_params |> Map.merge(query)
  end

  def default_params do
    %{"api_key" => api_key}
  end

  def api_key do
    Application.get_env(:letterboxd_cal, :tmdb_api_key)
  end
end
