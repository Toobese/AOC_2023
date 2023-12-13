defmodule Main do
    def main(times, records) do
        times
        |> Enum.zip(records)
        |> Enum.reduce(1, fn {time, record}, acc ->
            acc * Main.count_wins(time, time, 0, record)
        end)
    end


    def count_wins(start_time, time, speed, record) do
        cond do
            time * speed > record   -> start_time + 1 - ((start_time - time) * 2)
            time == 0               -> 0
            time * speed <= record  -> Main.count_wins(start_time, time - 1, speed + 1, record)
        end
    end

end

times = File.read!("day6_input.txt") |> String.split("\n") |> Enum.fetch!(0) |> String.split(~r/ +/) |> Enum.map(&String.to_integer/1)
records = File.read!("day6_input.txt") |> String.split("\n") |> Enum.fetch!(1) |> String.split(~r/ +/) |> Enum.map(&String.to_integer/1)
IO.inspect(Main.main(times, records))
