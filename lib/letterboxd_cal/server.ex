defmodule LetterboxdCal.Server do
  @moduledoc """
  Serves the iCal calendar over HTTP using Plug
  """

  use Plug.Router

  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/movies.ics" do
    conn
    |> put_resp_content_type("text/calendar")
    |> send_resp(200, LetterboxdCal.Calendar.ical)
  end

  match _ do
    conn |> send_resp(404, "404 Not Found")
  end
end

