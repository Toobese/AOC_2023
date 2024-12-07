defmodule MapDrawer do
  def draw(map_of_maps) do
    map_of_maps
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.map(fn {y, x_map} ->
      x_map
      |> Enum.to_list()
      |> Enum.sort()
      |> Enum.map(fn {_x, value} ->
        format_value(value)
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
  end

  defp format_value(value) when value < 10, do: " " <> Integer.to_string(value)
  defp format_value(value), do: Integer.to_string(value)


  def write_to_file(map_of_maps, filename) do
    content = draw(map_of_maps)
    File.write(filename, content)
  end
end

defmodule Main do
   def main(path) do
      map = Main.handle_input(path)
      [max_x, max_y] = [hd(Enum.reverse(Enum.sort(Map.keys(map)))), hd(Enum.reverse(Enum.sort(Map.keys(Map.get(map, 0)))))]
      Main.check_node({0, 0}, "d", max_x, max_y, 0, map, %{}, %{0 => %{0 => 0}}, [], 0)
      |> Map.get(max_y)
      |> Map.get(max_x)
   end

   def handle_input(path) do path
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce([%{}, 0], fn x, [map, index] ->
            [Map.put_new(map, index, Enum.reduce(String.graphemes(x), [%{}, 0], fn z, [map2, index2] -> [Map.put_new(map2, index2, String.to_integer(z)), index2 + 1] end) |> hd()), index + 1]
         end)
      |> hd()
   end

   def check_node({x, y}, direction, max_x, max_y, moved, map, visited, routes, queue, current) do
      [new_queue, new_routes, new_visited] = Main.get_reachable_coordinates({x, y}, direction, moved, max_x, max_y)
      |> Enum.reduce([[], routes, visited], fn {x_2, y_2, dir, moving}, [q, r, v] ->
            distance = current + Main.get_range_items(map, {x, y}, {x_2, y_2}, dir)
            if distance < Main.get_item(r, {x_2, y_2}) do
               [q ++ [[distance, {x_2, y_2}, dir, moving]],
               Map.update(r, y_2, %{x_2 => distance}, fn inner_map -> Map.put(inner_map, x_2, distance) end),
               Map.update(v, {x_2, y_2, dir, moving}, distance, fn _ -> distance end)]
            else
               case Map.has_key?(v, {x_2, y_2, dir, moving}) do
                  true  ->
                     if distance < Map.get(v, {x_2, y_2, dir, moving}) do
                        [q ++ [[distance, {x_2, y_2}, dir, moving]], r, Map.update(v, {x_2, y_2, dir, moving}, distance, fn _ -> distance end)]
                     else
                        [q, r, v]
                     end
                  false -> [q ++ [[distance, {x_2, y_2}, dir, moving]], r, Map.update(v, {x_2, y_2, dir, moving}, distance, fn _ -> distance end)]
               end
         end end)
      newer_queue = queue ++ Enum.sort(new_queue)
      case length(newer_queue) do
         0 ->
            new_routes

         _ ->
            [dist, {x_3, y_3}, dir, new_moved] = hd(newer_queue)
            Main.check_node({x_3, y_3}, dir, max_x, max_y, new_moved, map, new_visited, new_routes, tl(newer_queue), dist)
   end end

   def get_reachable_coordinates(stepsize\\3, {x, y}, direction, moved, max_x, max_y) do case direction do
      horizontal when horizontal in ["l", "r"] ->
         list = case [min(max_y - y, stepsize), min(y, stepsize)] do
            [0, _] -> Enum.map(1..min(y, stepsize), fn z -> {x, y - z, "u", z} end)
            [_, 0] -> Enum.map(1..min(max_y - y, stepsize), fn z -> {x, y + z, "d", z} end)
            [_, _] -> Enum.map(1..min(max_y - y, stepsize), fn z -> {x, y + z, "d", z} end) ++ Enum.map(1..min(y, stepsize), fn z -> {x, y - z, "u", z} end)
         end
         case direction do
            "l" -> if min(x, stepsize - moved) > 0, do: list ++ Enum.map(1..min(x, stepsize - moved), fn z -> {x - z, y, "l", z + moved} end), else: list
            "r" -> if min(max_x - x, stepsize - moved) > 0, do: list ++ Enum.map(1..min(max_x - x, stepsize - moved), fn z -> {x + z, y, "r", z + moved} end), else: list
         end

      vertical when vertical in ["u", "d"] ->
         list = case [min(max_x - x, stepsize), min(x, stepsize)] do
            [0, _] -> Enum.map(1..min(x, stepsize), fn z -> {x - z, y, "l", z} end)
            [_, 0] -> Enum.map(1..min(max_x - x, stepsize), fn z -> {x + z, y, "r", z} end)
            [_, _] -> Enum.map(1..min(max_x - x, stepsize), fn z -> {x + z, y, "r", z} end) ++ Enum.map(1..min(x, stepsize), fn z -> {x - z, y, "l", z} end)
         end
         case direction do
            "u" -> if min(y, stepsize - moved) > 0, do: list ++ Enum.map(1..min(y, stepsize - moved), fn z -> {x, y - z, "u", z + moved} end), else: list
            "d" -> if min(max_y - y, stepsize - moved) > 0, do: list ++ Enum.map(1..min(max_y - y, stepsize - moved), fn z -> {x, y + z, "d", z + moved} end), else: list
         end
   end end

   def get_range_items(map, {x, y}, {x_2, y_2}, direction) do case direction do
      "r" -> Enum.reduce(x+1..x_2, 0, fn x_3, acc -> acc + Main.get_item(map, {x_3, y}) end)
      "u" -> Enum.reduce(y-1..y_2, 0, fn y_3, acc -> acc + Main.get_item(map, {x, y_3}) end)
      "l" -> Enum.reduce(x-1..x_2, 0, fn x_3, acc -> acc + Main.get_item(map, {x_3, y}) end)
      "d" -> Enum.reduce(y+1..y_2, 0, fn y_3, acc -> acc + Main.get_item(map, {x, y_3}) end)
      # [0, 0] -> Main.get_item(map, {x, y})
   end end
   def get_item(map, {x, y}), do: Map.get(Map.get(map, y, %{x => nil}), x, nil)
end

IO.inspect(Main.main("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt"))
