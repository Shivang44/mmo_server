defmodule ServerWeb.CharacterController do
  # use ServerWeb, :controller

  # alias Server.Accounts
  # alias Server.Accounts.Character

  # action_fallback ServerWeb.FallbackController

  # def index(conn, {"user_id" => user_id, "username" => username, "password" => password}) do
  #   characters = Accounts.list_characters(user_id)
  #   render(conn, "index.json", characters: characters)
  # end

  # def create(conn, params) do
  #   with {:ok, %Character{} = character} <- Accounts.create_character(params) do
  #     conn
  #     |> put_status(:created)
  #     |> render("show.json", character: character)
  #   end
  # end

end
