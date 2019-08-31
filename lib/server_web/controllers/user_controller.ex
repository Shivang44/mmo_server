defmodule ServerWeb.UserController do
  use ServerWeb, :controller

  alias Server.Accounts
  alias Server.Accounts.User

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.create_user(email, password) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.authenticate(email, password) do
      conn
      |> put_status(:accepted)
      |> render("show.json", user: user)
    end
  end
end
