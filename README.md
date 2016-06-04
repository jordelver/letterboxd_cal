# LetterboxdCal

Makes release dates for films in your Letterboxd watchlist available as an iCal
calendar.

## Environment

The following environment variables must be set.

`LETTERBOXD_USERNAME` to your...Letterboxd username.

`DATABASE_URI` to `postgresql://<username>:<password>@<host>/<database>`

## Prerequisites

* Elixir 1.2
* PostgreSQL

## Setup

To start the web server

    env PORT=4000 mix server

