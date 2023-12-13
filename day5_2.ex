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
        |> Enum.reduce({[], []}, fn
            line, {current_group, acc} ->
                if line == "" do
                    {[], acc ++ [Enum.reverse(current_group)]}
                else
                    numbers = String.split(line, " ") |> Enum.map(&String.to_integer/1)
                    {[numbers | current_group], acc}
                end
            end)
        |> (fn {current_group, acc} ->
                if Enum.empty?(current_group) do
                    acc
                else
                    acc ++ [Enum.reverse(current_group)]
                end
            end).()
    end
end

defmodule Main do

    def values_helper(values, seed, categories) do case values do
        [h | t] ->
            [soil, seed_index, store] = h
            range = seed_index + store - 1
            {low, high} = seed

            cond do
                low < seed_index and high > range ->
                    bottom = Main.values_helper(t, {low, seed_index - 1}, categories)
                    top = Main.values_helper(t, {range + 1, high}, categories)
                    middle = Main.category_helper(categories, {soil, soil + (range - seed_index)})
                    Enum.min([bottom] ++ [top] ++ [middle])

                low < seed_index and high < seed_index ->
                    Main.values_helper(t, {low, high}, categories)

                low < seed_index ->
                    bottom = Main.values_helper(t, {low, seed_index - 1}, categories)
                    middle = Main.category_helper(categories, {soil, soil + (high - seed_index)})
                    Enum.min([bottom] ++ [middle])

                low > range ->
                    Main.values_helper(t, {low, high}, categories)

                high <= range ->
                    Main.category_helper(categories, {soil + (low - seed_index), soil + (high - seed_index)})

                true ->
                    top = Main.values_helper(t, {range + 1, high}, categories)
                    middle = Main.category_helper(categories, {soil + (low - seed_index), soil + (range - seed_index)})
                    Enum.min([top] ++ [middle])
            end

        [] ->
            Main.category_helper(categories, seed)
        end
    end


    def category_helper(categories, seed) do case categories do
        [h | t] ->
            Main.values_helper(h, seed, t)

        [] ->
            elem(seed, 0)
        end
    end


    def main(seeds, categories) do
        seeds
        |> Enum.map(fn seed -> Main.category_helper(categories, seed) end)
        |> Enum.min()
    end
end


categories = Categoriser.map_from_file("day5_input.txt")
seeds = File.read!("day5_input.txt")
        |> String.split("\n")
        |> Enum.fetch!(0)
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.map(fn [a, b] -> {a, a+b-1} end)

IO.inspect(Main.main(seeds, categories), charlists: false)
