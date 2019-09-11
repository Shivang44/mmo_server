defmodule ServerWeb.CharacterController do
  use ServerWeb, :controller

  plug :authenticate

  alias Server.Accounts
  alias Server.Accounts.Character

  action_fallback ServerWeb.FallbackController

  defp authenticate(conn, _) do
    access_token = conn |> get_req_header("access_token") |> List.first
    case Accounts.authenticate(%{"user_id" => conn.params["user_id"], "access_token" => access_token}) do
      :ok -> conn
      :error -> conn |> put_status(:unauthorized) |> put_view(ServerWeb.ErrorView) |> render("error.json", msg: "Invalid access token") |> halt()
    end
  end

  def index(conn, %{"user_id" => user_id}) do
    characters = Accounts.list_characters(user_id)
    render(conn, "index.json", characters: characters)
  end

  def create(conn, params) do
    with {:ok, %Character{} = character} <- Accounts.create_character(params) do
      conn
      |> put_status(:created)
      |> render("show.json", character: character)
    end
  end

end
