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
        map = File.read!(path) |> String.split("\n") |> Enum.map(fn x -> List.to_tuple(String.split(x, "")) end) |> List.to_tuple()
        {x, y} = MapSearch.find_coordinates(map, "S")
        [{{x, y - 1}, ".", "u"}, {{x + 1, y}, "J", "r"}, {{x, y + 1}, "|", "d"}, {{x - 1, y}, "", "l"}]
        |> Enum.reduce_while(nil, fn {coordinates, char, dir}, _acc ->
            result = Main.count_pipes(map, coordinates, char, dir, 0)
            if result == false, do: {:cont, nil}, else: {:halt, result/2} end)
    end

    def count_pipes(map, coordinates, char, dir, acc) do case @directions[dir][char] do
        nil -> false
        1 -> acc + 1
        {coords_update_func, next_dir} ->
            {x, y} = coords_update_func.(coordinates)
            next_character = elem(elem(map, y), x)
            count_pipes(map, {x, y}, next_character, next_dir, acc + 1)
    end end

    def increment_x({x, y}), do: {x + 1, y}
    def decrement_x({x, y}), do: {x - 1, y}
    def increment_y({x, y}), do: {x, y + 1}
    def decrement_y({x, y}), do: {x, y - 1}
end

IO.inspect(Main.main("day10_input.txt"))
