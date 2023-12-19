defmodule Main do
   def main(path) do
      [galaxy, star_count] = Main.handle_input(path)
      e_rows = Main.get_empty_rows(galaxy)
      e_columns = galaxy |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> Main.get_empty_rows()
      Enum.to_list(0..star_count-1)
      |> Enum.map(fn x -> Main.find_coordinates(galaxy, "#{x}", e_rows, e_columns, 1000000) end)
      |> Main.calculate_distances()
   end

   def handle_input(path) do path
      |> File.read!()
      |> String.graphemes()
      |> Enum.reduce([[[]], 0], fn x, [galaxy, label] -> case x do
            "#" -> [[hd(galaxy)++["#{label}"]]++tl(galaxy), label + 1]
            "\n" -> [[[]]++galaxy, label]
            "." -> [[hd(galaxy)++["."]]++tl(galaxy), label]
         end end)
      |> (fn [galaxy, star_count] -> [Enum.reverse(galaxy), star_count] end).()
   end

   def get_empty_rows(galaxy) do galaxy
      |> Enum.reduce([[], 0], fn x, [e_columns, column] -> case MapSet.size(MapSet.new(x)) do
         1 -> [e_columns ++ [column], column + 1]
         _ -> [e_columns, column + 1]
         end end)
      |> hd()
   end

   def find_coordinates(galaxy, target, x_offset, y_offset, increase_by) do galaxy
      |> Enum.with_index()
      |> Enum.reduce_while(nil, fn {row, row_index}, acc -> case Enum.find_index(row, fn element -> element == target end) do
         nil -> {:cont, acc}
         column_index ->
            x = column_index + (increase_by - 1) * length(Enum.filter(y_offset, fn pos -> if pos < column_index, do: pos end))
            y = row_index + (increase_by - 1) * length(Enum.filter(x_offset, fn pos -> if pos < row_index, do: pos end))
            {:halt, {x, y}}
         end end)
   end

   def calculate_distances(stars) do case stars do
      [{x, y} | t] -> Enum.reduce(t, 0, fn {x_2, y_2}, distance -> (abs(x - x_2) + abs(y - y_2)) + distance end) + Main.calculate_distances(t)
      [] -> 0
   end end
end

IO.inspect(Main.main("day11_input.txt"))
