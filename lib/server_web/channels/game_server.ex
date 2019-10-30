defmodule ServerWeb.GameServerChannel do
  use Phoenix.Channel
  alias ServerWeb.Presence

  def join("room:" <> room, _message, socket) do
    IO.puts "Client joined game_server channel #{inspect room}"
    send(self(), :after_join)
    {:ok, assign(socket, :room, room)}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  @spec handle_info(:after_join, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.character_id, %{
      user_id: socket.assigns.user_id
    })
    IO.puts "Presence: #{inspect Presence.list("room:" <> socket.assigns.room)}"
    {:noreply, socket}
  end

  def handle_in("client_input", input, socket) do
    # broadcast!(socket, "world_update", %{body: "world_update"})
    Server.InputQueue.push(%{character_id: socket.assigns.character_id, input: input})
    {:reply, {:ok, %{}}, socket}
  end
end
