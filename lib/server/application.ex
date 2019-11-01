defmodule Server.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Server.Repo,
      ServerWeb.Endpoint
    ]

    children_gameserver = children ++ [
      ServerWeb.Presence,
      Server.InputQueue,
      Server.TickExecuter,
      Server.TickScheduler  
    ]



    IO.inspect children

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Server.Supervisor]

    # If we're running our phoenix server with `mix phx.server`, i.e. not `mix test`, run game server as well
    if {:ok, true} == Application.fetch_env(:phoenix, :serve_endpoints) do
      Supervisor.start_link(children_gameserver, opts)
    else
      Supervisor.start_link(children, opts)
    end

  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
