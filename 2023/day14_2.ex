defmodule Main do
   def main(path) do
      setup = path |> Main.handle_input()
      runs = Enum.map(1..200, fn _ -> 0 end)
      Enum.reduce_while(runs, [%{}, setup, 0], fn _x, [visited, platform, itteration] -> case Map.has_key?(visited, platform) do
         true ->
            offset = Map.fetch!(visited, platform)
            cycle_size = itteration - offset
            final_platform = Map.fetch!(visited, rem((1000000000 - offset), cycle_size) + offset)
            |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
            |> Enum.reduce(0, fn x, acc -> acc + Main.calculate_weight(x) end)
            {:halt, final_platform}
         false -> {:cont, [Map.put(visited, platform, itteration) |> Map.put(itteration, platform), Main.rotate(platform), itteration + 1]}
      end end)
   end

   def rotate(map) do map
      |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
      |> Enum.reduce([], fn x, acc -> acc ++ [Main.handle_line(x)] end)
      |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
      |> Enum.reduce([], fn x, acc -> acc ++ [Main.handle_line(x)] end)
      |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> Enum.map(fn x -> Enum.reverse(x) end)
      |> Enum.reduce([], fn x, acc -> acc ++ [Main.handle_line(x)] end)
      |> Enum.map(fn x -> Enum.reverse(x) end) |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> Enum.map(fn x -> Enum.reverse(x) end)
      |> Enum.reduce([], fn x, acc -> acc ++ [Main.handle_line(x)] end)
      |> Enum.map(fn x -> Enum.reverse(x) end)
   end

   def handle_line(map) do map
      |> Enum.reduce([map, 0], fn symbol, [line, index] -> case symbol do
            "O" -> [Main.roll_rock(line, index), index + 1]
            "." -> [line, index + 1]
            "#" -> [line, index + 1]
         end end)
      |> hd()
   end

   def calculate_weight(line) do line
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {symbol, weight}, acc -> case symbol do
            "O" -> weight + 1 + acc
            "." -> acc
            "#" -> acc
         end end)
   end

   def roll_rock(line, index) do
      move = Enum.slice(line, 0, index)
      |> Enum.reverse()
      |> Enum.reduce_while(0, fn symbol, move_n_spaces -> case symbol do
            "O" -> {:halt, move_n_spaces}
            "." -> {:cont, move_n_spaces + 1}
            "#" -> {:halt, move_n_spaces}
         end end)

      line |> List.pop_at(index) |> elem(1) |> List.insert_at(index - move, "O")
   end

   def handle_input(path) do path
      |> File.read!() |> String.split("\n") |> Enum.map(fn z -> String.graphemes(z) end)
   end
end

IO.inspect(Main.main("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt"))
