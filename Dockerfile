FROM elixir

EXPOSE 8080

COPY ./ .

RUN mix local.hex --force

RUN mix deps.get

RUN mix local.rebar --force

CMD mix phx.server

#source .env && mix phx.server