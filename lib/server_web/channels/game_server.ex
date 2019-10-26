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

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      character_id: socket.assigns.character_id
    })
    IO.puts "Presence: #{inspect Presence.list("room:" <> socket.assigns.room)}"
    {:noreply, socket}
  end

  def handle_in("client_input", input, socket) do
    # broadcast!(socket, "world_update", %{body: "world_update"})
    # TODO: Authorize user. If they do not own the character, reject input (perhaps dc and ban user)
    Server.InputQueue.push(input)
    {:reply, {:ok, %{}}, socket}
  end
end
