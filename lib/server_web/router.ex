defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ServerWeb do
    pipe_through :api
    resources "/users", UserController, only: [:create, :index] do
      resources "/characters", CharacterController, only: [:create, :index]
    end

    post "/login", UserController, :login
  end
end
