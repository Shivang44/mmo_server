defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ServerWeb do
    pipe_through :api
    post "/users", UserController, :create
    get "/users", UserController, :index
    post "/login", UserController, :login
  end
end
