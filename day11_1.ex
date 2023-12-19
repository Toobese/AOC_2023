defmodule Main do
    def label_stars(map, number) do case map do
        [h | t] ->
            [line, num] = Main.label_helper(h, number)
            [line] ++ Main.label_stars(t, num)
        [] -> []
    end end

    def label_stars(map, number) do case map do
        [h | t] ->
            [line, num] = Main.label_helper(h, number)
            [line] ++ Main.label_stars(t, num)
        [] -> []
    end end

    def label_helper(line, number) do line
        |> Enum.reduce([[], number], fn x, acc ->
            num = hd(tl(acc))
            if x == "." do
                [hd(acc) ++ ["."], num]
            else
                [hd(acc) ++ ["#{num}"], num + 1]
            end
        end)
    end

    def get_empty_row(map) do
        indices = Enum.reduce(map, [[], 0], fn x, acc ->
            if MapSet.size(MapSet.new(x)) == 1 do
                [hd(acc) ++ tl(acc), hd(tl(acc)) + 1]
            else
                [hd(acc), hd(tl(acc)) + 1]
            end
        end)
        hd(indices)
    end

    def find_coordinates(map, target, x_offset, y_offset, increase_by) do map
        |> Enum.with_index()
        |> Enum.reduce_while(nil, fn {row, row_index}, acc ->
            column_index = Enum.find_index(row, fn element -> element == target end)
            if column_index == nil do
                {:cont, acc}
            else
                x = column_index + (increase_by - 1) * length(Enum.filter(y_offset, fn pos -> if pos < column_index, do: pos end))
                y = row_index + (increase_by - 1) * length(Enum.filter(x_offset, fn pos -> if pos < row_index, do: pos end))
                {:halt, {x, y}}
            end end)
    end

    def calculate_distances(stars) do case stars do
        [h | t] ->
            Main.get_distances_from_star(h, t) + Main.calculate_distances(t)

            [] -> 0
    end end

    def get_distances_from_star({x, y}, other_stars) do case other_stars do
        [h | t] ->
            {x_2, y_2} = h
            dist = abs(x - x_2) + abs(y - y_2)
            dist + Main.get_distances_from_star({x, y}, t)

        [] -> 0
    end end
end



map = File.read!("day11_input.txt") |> String.split("\n") |> Enum.map(fn x -> String.graphemes(x) end)
galaxy = Main.label_stars(map, 0)
x_ind = Main.get_empty_row(galaxy)
y_ind = galaxy |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> Main.get_empty_row()

Enum.to_list(0..446)
|> Enum.map(fn x -> Main.find_coordinates(galaxy, "#{x}", x_ind, y_ind, 2) end)
|> Main.calculate_distances()
|> IO.inspect()
