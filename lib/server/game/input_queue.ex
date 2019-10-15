defmodule Server.InputQueue do
    use Agent
    
    def start_link(_arg) do
        Agent.start_link(fn -> :queue.new end, name: __MODULE__)
    end

    def push(input) do
        Agent.update(__MODULE__, fn(queue) -> :queue.in(input, queue) end)
    end

    def pop do
        Agent.get_and_update(__MODULE__, fn(queue) -> {:queue.out(queue) |> elem(0) |> elem(1), :queue.out(queue) |> elem(1)} end)
    end

    def length do
        Agent.get(__MODULE__, fn(queue) -> :queue.len(queue) end)
    end


end