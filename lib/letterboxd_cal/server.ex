defmodule LetterboxdCal.Server do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/movies.ics" do
    conn |> send_resp(200, ":D")
  end

  match _ do
    conn |> send_resp(404, "404 Not Found")
  end
end

