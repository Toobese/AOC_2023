defmodule Main do

    def main(list) do case list do
        [0, _, 0] -> 0
        [0, 0]    -> 0
        [0]       -> 0
        [_h | _t] -> hd(Enum.reverse(list)) + Main.main(Main.get_next(list))
    end end

    def get_next(list) do
        Enum.chunk_every(list, 2, 1, :discard)
        |> Enum.reduce([], fn [a, b], acc -> acc ++ [b - a] end)
    end
end


File.read!("day9_input.txt")
|> String.split("\n")
|> Enum.map(fn x -> String.split(x, " ") end)
|> Enum.map(fn lst -> Enum.map(lst, fn x -> String.to_integer(x) end) end)
|> Enum.reduce(0, fn x, acc -> acc + Main.main(x) end)
|> IO.inspect()
