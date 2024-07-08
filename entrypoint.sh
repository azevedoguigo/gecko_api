#!/bin/sh

while ! pg_isready -q -h $DB_HOST -p 5432 -U $POSTGRES_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

mix ecto.create
mix ecto.migrate

exec mix phx.server
