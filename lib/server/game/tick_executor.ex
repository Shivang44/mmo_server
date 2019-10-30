defmodule Server.TickExecuter do
    use GenServer
    alias ServerWeb.Presence

    # Public API
    def start_link(_args) do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def tick do
        GenServer.call(__MODULE__, :tick)
    end

    # Genserver Implementation
    @impl true
    def init(state) do
        {:ok, state}
    end

    @impl true
    def handle_call(:tick, _from, state) do
        process_inputs()
        send_world_state()
        {:reply, state, state}
    end

    # Helper functions
    def process_inputs() do
        with true <- Server.InputQueue.length > 0,
             input <- Server.InputQueue.pop
        do
            case input do
                %{character_id: character_id, input: %{"move" => %{"x" => x, "y" => y, "z" => z}}} ->
                    input = %{character_id: character_id, x: x, y: y, z: z}
                    with true <- Server.Characters.validate_movement(input) do
                        Server.Characters.update_position(input)
                    end
            end
            process_inputs()
        end
    end

    def send_world_state() do
        # For now we will only send updates to room 0:0. Eventually this will be loop over all rooms i:j
        "room:0,0" |> Presence.list |> Map.keys |> Server.Characters.positions
        # IO.puts "Sent world update to room 0,0: #{inspect Presence.list("room:0,0")}"
    end

    def valid_input(input) do
        true
    end
end
