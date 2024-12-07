defmodule Main do
   def main(path) do path
      |> Main.handle_input()
      |> Enum.reduce(0, fn x, acc -> acc + Main.handle_line(x) end)
   end

   def handle_line(map) do map
      |> Enum.reduce([map, 0], fn symbol, [line, index] -> case symbol do
            "O" -> [Main.roll_rock(line, index), index + 1]
            "." -> [line, index + 1]
            "#" -> [line, index + 1]
         end end)
      |> hd() |> Main.calculate_weight()
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
      |> File.read!() |> String.split("\n") |> Enum.map(fn z -> String.graphemes(z) end) |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> IO.inspect()
   end
end

IO.inspect(Main.main("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt"))
