defmodule LetterboxdCal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(LetterboxdCal.Db, [Moebius.get_connection])
    ]

    opts = [strategy: :one_for_one, name: LetterboxdCal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
