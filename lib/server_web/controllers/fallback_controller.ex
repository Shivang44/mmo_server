defmodule ServerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ServerWeb, :controller

  def call(conn, {:error, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ServerWeb.ErrorView)
    |> render("error.json", msg: msg)
  end
end
