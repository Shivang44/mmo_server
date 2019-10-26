defmodule Server.TickScheduler do
    use Task

    @tick_rate 1
    @time_per_tick 1000 / @tick_rate |> Decimal.from_float |> Decimal.to_integer

    def start_link(_args) do
        Task.start_link(__MODULE__, :schedule_ticks, [])
    end

    def schedule_ticks() do
        {uSec, _} = :timer.tc(Server.TickExecuter, :tick, [])
        IO.puts "Server tick executed in #{inspect uSec / 1000} milliseconds"
        Process.sleep(@time_per_tick) # TODO Sleep only for time left until next tick
        schedule_ticks()
    end

end
