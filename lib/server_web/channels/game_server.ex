defmodule ServerWeb.GameServerChannel do
  use Phoenix.Channel

  def join("game_server", _message, socket) do
    IO.puts "Client joined game_server channel"
    {:ok, socket}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("client_input", input, socket) do
    # broadcast!(socket, "world_update", %{body: "world_update"})
    Server.InputQueue.push(input)
    {:reply, {:ok, %{}}, socket}
  end
end
