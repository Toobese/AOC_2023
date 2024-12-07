defmodule Main do
   def main(path) do
      map = path
      |> Main.handle_input()

      y_axis = Map.keys(map) |> Enum.sort()
      x_axis = Map.keys(Map.get(map, 0)) |> Enum.sort()

      highest_ver = Enum.reduce(y_axis, 0, fn y, highest ->
         left = Main.follow_beam(map, %{}, "r", {hd(x_axis), y})
         |> Map.values()
         |> Enum.reduce(0, fn x, acc -> acc + length(Map.values(x)) end)
         right = Main.follow_beam(map, %{}, "l", {hd(Enum.reverse(x_axis)), y})
         |> Map.values()
         |> Enum.reduce(0, fn x, acc -> acc + length(Map.values(x)) end)
         max(max(highest, left), right)
      end)

      highest_hor = Enum.reduce(x_axis, 0, fn x, highest ->
         top = Main.follow_beam(map, %{}, "d", {x, hd(y_axis)})
         |> Map.values()
         |> Enum.reduce(0, fn x, acc -> acc + length(Map.values(x)) end)
         bottom = Main.follow_beam(map, %{}, "u", {x, hd(Enum.reverse(y_axis))})
         |> Map.values()
         |> Enum.reduce(0, fn x, acc -> acc + length(Map.values(x)) end)
         max(max(highest, top), bottom)
      end)
      max(highest_hor, highest_ver)
   end

   def handle_input(path) do path
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce([%{}, 0], fn x, [map, index] ->
            [Map.put_new(map, index, Enum.reduce(String.graphemes(x), [%{}, 0], fn z, [map2, index2] -> [Map.put_new(map2, index2, z), index2 + 1] end) |> hd()), index + 1]
         end)
      |> hd()
   end

   def follow_beam(map, visited, direction, {x, y}) do case Main.check_index(map, {x, y}) do
         false -> visited
         true  -> case Enum.member?(Main.get_item(visited, {x, y}), direction) do
            true  -> visited
            false ->
               new_visited = Main.add_item(visited, {x, y}, [direction])
               case Main.get_item(map, {x, y}) do
                  "." ->
                     Main.follow_beam(map, new_visited, direction, Main.update_coords({x, y}, direction))

                  "/" ->
                     case direction do
                        "r" -> Main.follow_beam(map, new_visited, "u", Main.update_coords({x, y}, "u"))
                        "l" -> Main.follow_beam(map, new_visited, "d", Main.update_coords({x, y}, "d"))
                        "d" -> Main.follow_beam(map, new_visited, "l", Main.update_coords({x, y}, "l"))
                        "u" -> Main.follow_beam(map, new_visited, "r", Main.update_coords({x, y}, "r"))
                     end

                  "|" ->
                     map1 = Main.follow_beam(map, new_visited, "u", Main.update_coords({x, y}, "u"))
                     Main.follow_beam(map, map1, "d", Main.update_coords({x, y}, "d"))

                  "-" ->
                     map1 = Main.follow_beam(map, new_visited, "l", Main.update_coords({x, y}, "l"))
                     Main.follow_beam(map, map1, "r", Main.update_coords({x, y}, "r"))

                  _df ->
                     case direction do
                        "r" -> Main.follow_beam(map, new_visited, "d", Main.update_coords({x, y}, "d"))
                        "l" -> Main.follow_beam(map, new_visited, "u", Main.update_coords({x, y}, "u"))
                        "d" -> Main.follow_beam(map, new_visited, "r", Main.update_coords({x, y}, "r"))
                        "u" -> Main.follow_beam(map, new_visited, "l", Main.update_coords({x, y}, "l"))
                     end end
   end end end

   def get_item(map, {x, y}), do: Map.get(Map.get(map, y, %{x => []}), x, [])
   def check_index(map, {x, y}), do: Map.has_key?(map, y) and Map.has_key?(Map.fetch!(map, y), x)
   def add_item(map, {x, y}, new_direction) do
      Map.update(map, y, %{x => new_direction}, fn inner_map ->
         Map.update(inner_map, x, new_direction, fn old_directions -> old_directions ++ new_direction end)
   end) end

   def update_coords({x, y}, direction) do case direction do
      "r" -> {x + 1, y}
      "l" -> {x - 1, y}
      "d" -> {x, y + 1}
      "u" -> {x, y - 1}
   end end
end

IO.inspect(Main.main("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt"))
