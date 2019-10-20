defmodule Server.TickExecuter do
    use GenServer

    def start_link(_args) do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def tick do
        GenServer.call(__MODULE__, :tick)
    end

    @impl true
    def init(state) do
        {:ok, state}
    end

    @impl true
    def handle_call(:tick, _from, state) do
        {:reply, state, state}
    end
end