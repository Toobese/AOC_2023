defmodule Main do
   def main(path) do Main.handle_input(path)
      |> Enum.map(fn x ->
            hor = Main.max_score(x, 100)
            ver = x
            |> Enum.map(fn z -> String.graphemes(z) end)
            |> Enum.zip()
            |> Enum.map(&Tuple.to_list/1)
            |> Enum.map(fn z -> Enum.join(z, "") end)
            |> Main.max_score(1)
            Enum.max([hor, ver])
         end)
      |> Enum.sum()
   end

   def max_score(input, multiplier) do input
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce([[0], 1], fn [_left, _right], [results, index] ->
            [[Main.check_mirror(Enum.split(input, index), multiplier)] ++ results, index + 1]
         end)
      |> hd() |> Enum.max()
   end

   def handle_input(path) do path
      |> File.read!()
      |> String.split("\n\n")
      |> Enum.map(fn x -> String.split(x, "\n") end)
   end

   def check_mirror({left, right}, multiplier) do
      misses = Enum.zip(Enum.reverse(left), right)
      |> Enum.map(fn {a, b} -> {String.graphemes(a), String.graphemes(b)} end)
      |> Enum.reduce_while(0, fn {a, b}, misses ->
            if misses > 1 do
               {:halt, misses}
            else
               {:cont, Enum.reduce(Enum.zip(a, b), 0, fn {l, r}, miss -> case l == r do
                  true  -> miss
                  false -> miss + 1
               end end) + misses}
            end
         end)
      if misses == 1, do: length(left) * multiplier, else: 0
   end
end

IO.inspect(Main.main("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt"))
