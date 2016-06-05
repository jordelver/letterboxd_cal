defmodule LetterboxdCal.Server do
  use Plug.Router

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

