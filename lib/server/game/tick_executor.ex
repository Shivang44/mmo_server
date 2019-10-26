defmodule Server.TickExecuter do
    use GenServer

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
            with true <- valid_input(input) do
                # Process Input
            end

            process_inputs()
        end
    end

    def send_world_state() do
        # IO.puts "Sent world state update to all clients"
    end

    def valid_input(input) do
        true
    end
end
