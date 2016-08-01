use Mix.Config

config :quantum, cron: [

  # 3AM
  "0 3 * * *": {LetterboxdCal.ImportMovies, :import},

  # 4AM
  "0 4 * * *": {LetterboxdCal.UpdateReleaseDates, :update},
]

