# MMO Server

This is an in-development server for an upcoming mobile MMO I'm creating.
It contains two main components:

- A (fully tested) REST server in phoenix that handles account-level tasks (creating an account, characters, etc)
- A server-authoritative gameserver that will handle actual gameplay logic (haven't started this)

# Server

To start the MMO server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.