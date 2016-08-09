# LetterboxdCal

Makes release dates for films in your Letterboxd watchlist available as an iCal
calendar.

## Environment

The following environment variables must be set.

`LETTERBOXD_USERNAME` to your...Letterboxd username.

`DATABASE_URI` to `postgresql://<username>:<password>@<host>/<database>`

`TMDB_API_KEY` to a valid themoviedb.org API key.

`PORT` to the port to use for the webserver (defaults to 4001)

## Prerequisites

* Elixir 1.3
* PostgreSQL

## Deployment

We're using the buildpack from https://github.com/HashNuke/heroku-buildpack-elixir
to deploy to Heroku.

## Setup

To start

    mix run --no-halt

