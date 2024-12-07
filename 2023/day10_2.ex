defmodule MapSearch do
    def find_coordinates(map, target) do map
        |> Tuple.to_list()
        |> Enum.with_index()
        |> Enum.reduce_while(nil, fn {row, row_index}, acc ->
            column_index = Enum.find_index(Tuple.to_list(row), fn element -> element == target end)
            if column_index == nil, do: {:cont, acc}, else: {:halt, {column_index, row_index}} end)
    end
end

defmodule Main do
    @directions %{
        "u" => %{"|" => {&Main.decrement_y/1, "u"}, "7" => {&Main.decrement_x/1, "l"}, "F" => {&Main.increment_x/1, "r"}, "S" => 1},
        "d" => %{"|" => {&Main.increment_y/1, "d"}, "J" => {&Main.decrement_x/1, "l"}, "L" => {&Main.increment_x/1, "r"}, "S" => 1},
        "l" => %{"L" => {&Main.decrement_y/1, "u"}, "-" => {&Main.decrement_x/1, "l"}, "F" => {&Main.increment_y/1, "d"}, "S" => 1},
        "r" => %{"J" => {&Main.decrement_y/1, "u"}, "-" => {&Main.increment_x/1, "r"}, "7" => {&Main.increment_y/1, "d"}, "S" => 1}
    }

    def main(path) do
        map = File.read!(path) |> String.split("\n") |> Enum.map(fn x -> List.to_tuple(String.graphemes(x)) end) |> List.to_tuple()
        {x, y} = MapSearch.find_coordinates(map, "S")
        pipes = Main.get_pipes(map, {x + 1, y}, "7", "r", %{y => [x]})
        sorted_pipes = Enum.into(pipes
        |> Enum.map(fn {key, list} -> {key, Enum.sort(list)} end), %{})
        |> IO.inspect()

        targets = sorted_pipes
        |> Main.get_between_pipes()
        |> MapSet.new()
        |> MapSet.to_list()
        |> Enum.map(fn {a, b} -> Main.is_it_in({a, b}, map, sorted_pipes[b]) end)
        |> Enum.sum()
        |> IO.inspect()
    end

    def get_pipes(map, {x_1, y_1}, char, dir, acc) do case @directions[dir][char] do
        nil -> false
        1 -> acc
        {coords_update_func, next_dir} ->
            {x_2, y_2} = coords_update_func.({x_1, y_1})
            next_character = elem(elem(map, y_2), x_2)
            store = Map.merge(%{y_1 => [x_1]}, acc, fn _vk, v1, v2 -> v1++v2 end)
            get_pipes(map, {x_2, y_2}, next_character, next_dir, Map.merge(%{y_1 => [x_1]}, acc, fn _vk, v1, v2 -> v1++v2 end))
    end end

    def get_between_pipes(pipes) do
        pipes
        |> Enum.reduce([], fn {key, value}, acc ->
            new_value = value
            |> Enum.chunk_every(2, 1, :discard)
            |> Enum.reduce([], fn [a, b], acc_2 ->
                diff = b - (a+1)
                if diff != 0, do: store = Main.get_points(a+1, key, b)++acc_2, else: acc_2
            end)
            new_value++acc
        end)
    end

    def get_points(x, y, b) do case x do
        ^b -> []
        _ ->
            [{x, y}]++get_points(x + 1, y, b)
    end end

    def is_it_in({x, y}, map, row) do
        neighbour_pipes = Enum.reduce_while(row, [], fn coord, acc ->
            if coord < x do
                char = elem(elem(map, y), coord)
                case char do
                    "F" -> {:cont, ["F"] ++ acc}
                    # "S" -> {:cont, ["F"] ++ acc}
                    "7" -> {:cont, (if acc == [], do: ["7"], else: [hd(acc) <> "7"] ++ tl(acc))}
                    "L" -> {:cont, ["L"] ++ acc}
                    "J" -> {:cont, (if acc == [], do: ["J"], else: [hd(acc) <> "J"] ++ tl(acc))}
                    "|" -> {:cont, ["|"] ++ acc}
                    _   -> {:cont, acc}
                end
            else
                {:halt, acc}
            end
        end)
        |> Enum.map(fn pipe -> case pipe do
            "FJ" -> 1
            "LJ" -> 2
            "L7" -> 1
            "F7" -> 2
            "|"  -> 1
        end end)
        |> Enum.sum()
        rem(neighbour_pipes, 2)

    end

    def increment_x({x, y}), do: {x + 1, y}
    def decrement_x({x, y}), do: {x - 1, y}
    def increment_y({x, y}), do: {x, y + 1}
    def decrement_y({x, y}), do: {x, y - 1}
end

Main.main("day10_input.txt")
