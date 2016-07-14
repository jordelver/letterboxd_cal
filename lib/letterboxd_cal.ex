defmodule LetterboxdCal do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {port, _} = Application.get_env(:letterboxd_cal, :port)
                |> to_string |> Integer.parse

    Logger.debug("Launching web server on port #{port}")

    children = [
      worker(LetterboxdCal.Db, [Moebius.get_connection]),
      Plug.Adapters.Cowboy.child_spec(:http, LetterboxdCal.Server, [], port: port)
    ]

    opts = [strategy: :one_for_one, name: LetterboxdCal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
