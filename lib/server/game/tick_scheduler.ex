defmodule Server.TickScheduler do
    use Task

    @tick_rate 100
    @time_per_tick 1000 / @tick_rate |> Decimal.from_float |> Decimal.to_integer

    def start_link(_args) do
        Task.start_link(__MODULE__, :schedule_ticks, [])
    end

    def schedule_ticks() do
        # TickExecuter.call({:tick})
        IO.puts "Called TickExecutor #{inspect @time_per_tick}"
        Process.sleep(@time_per_tick)
        schedule_ticks()
    end
    
end