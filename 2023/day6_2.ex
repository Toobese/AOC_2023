defmodule Main do
    def main(start_time, time, speed, record) do
        cond do
            time * speed > record   -> start_time + 1 - ((start_time - time) * 2)
            time * speed <= record  -> Main.main(start_time, time - 1, speed + 1, record)
            time == 0               -> 0
        end
    end

end

time = File.read!("day6_input.txt") |> String.split("\n") |> Enum.fetch!(0) |> String.replace(~r/ +/, "") |> String.to_integer()
record = File.read!("day6_input.txt") |> String.split("\n") |> Enum.fetch!(1) |> String.replace(~r/ +/, "") |> String.to_integer()
IO.inspect(Main.main(time, time, 0, record))
