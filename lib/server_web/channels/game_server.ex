defmodule ServerWeb.GameServerChannel do
  use Phoenix.Channel

  def join("game_server", _message, socket) do
    IO.puts "Client joined game_server channel"
    {:ok, socket}
  end

  def join(_private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

end
