defmodule Categoriser do

    def map_from_file(file_path) do
        file_path
        |> File.read!()
        |> map_lines()
    end


    def map_lines(input) do
        input
        |> String.split("\n")
        |> Enum.drop(1)
        |> Enum.reduce({[], [], 1}, fn
            line, {current_group, acc, cat_number} ->
                if line == "" do
                    {[], acc ++ [{:"cat#{cat_number}", Enum.reverse(current_group)}], cat_number + 1}
                else
                    numbers = String.split(line, " ") |> Enum.map(&String.to_integer/1)
                    {[numbers | current_group], acc, cat_number}
                end
            end)
        |> (fn {current_group, acc, cat_number} ->
                if Enum.empty?(current_group) do
                    acc
                else
                    acc ++ [{:"cat#{cat_number}", Enum.reverse(current_group)}]
                end
            end).()
        |> Enum.into(%{})
    end
end

defmodule Main do

    def helper(values, seed) do case values do
        [h | t] ->
            [soil, seed_index, range] = h

            if (seed < seed_index) or (seed_index+range-1 < seed) do
                Main.helper(t, seed)
            else
                {[], soil + (seed - seed_index)}
            end

        [] ->
            {[], seed}
        end
    end


    def main(seeds, categories) do
        seeds
        |> Enum.map(fn seed ->
            initial_acc = seed
            {_, position} = Enum.flat_map_reduce(categories, initial_acc, fn categorie, acc ->
                values = elem(categorie, 1)
                Main.helper(values, acc)
            end)
            position
        end)
        |> Enum.min()
    end
end


categories = Categoriser.map_from_file("day5_input.txt")
seeds = File.read!("day5_input.txt")
        |> String.split("\n")
        |> Enum.fetch!(0)
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)

# IO.inspect(seeds)
IO.inspect(Main.main(seeds, categories), charlists: false)
