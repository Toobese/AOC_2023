defmodule Main do

    def main(hands, order_map) do
        Main.create_ranking(hands)
        |>  Enum.sort(fn a, b ->
                Enum.reduce_while(Enum.zip(a, b), :eq, fn {x, y}, acc ->
                    case {order_map[x], order_map[y]} do
                        {x_val, y_val} when x_val == y_val -> {:cont, acc}
                        {x_val, y_val} when x_val < y_val -> {:halt, true}
                        _ -> {:halt, false}
                    end
                end) == true
            end)
        |>  Enum.map(fn x ->
                x
                |> Enum.reverse(x)
                |> hd()
                |> String.replace(~r/^0+/, "")
                |> String.to_integer()
            end)
        |>  Enum.with_index()
        |>  Enum.reduce(0, fn {bet, index}, acc ->
                acc + (index + 1) * bet
            end)
    end


    def create_ranking(hands) do case hands do
        [h | t] ->
            {hand, bet} = h
            sorted_hand = Enum.frequencies(hand)
                          |> Enum.map(fn {key, value} -> [value, key] end)
                          |> Enum.sort()
                          |> Enum.reverse()

            {j_tuples, other_tuples} = Enum.split_with(sorted_hand, fn [_count, value] -> value == "D" end)
            final_hand = Main.remove_j(j_tuples, other_tuples)
            Main.calculate_score(final_hand, hand, bet) ++ Main.create_ranking(t)

        [] -> []
    end end


    def remove_j(j, rest) do
        case [j, rest] do
            [[_h | _t], [h | t]] ->
                [count, value] = h
                [j_count, _] = hd(j)
                [[j_count + count, value]] ++ t

            [[_h | _t], []] -> j

            [_, _] -> rest
        end
    end


    def calculate_score(sorted_hand, hand, bet) do
        new_bet = String.pad_leading(bet, 4, "0")
        case [length(sorted_hand), hd(sorted_hand)] do
            [1, [_, _]] -> [["7"] ++ hand ++ [new_bet]]
            [2, [4, _]] -> [["6"] ++ hand ++ [new_bet]]
            [2, [_, _]] -> [["5"] ++ hand ++ [new_bet]]
            [3, [3, _]] -> [["4"] ++ hand ++ [new_bet]]
            [3, [_, _]] -> [["3"] ++ hand ++ [new_bet]]
            [4, [_, _]] -> [["2"] ++ hand ++ [new_bet]]
            [5, [_, _]] -> [["1"] ++ hand ++ [new_bet]]
        end
    end


    def calculate_answer(end_list, reference_list) do
        Enum.sort(end_list, fn {list1, _}, {list2, _} ->
            Enum.reduce_while(list1, {:cont, list2}, fn element1, {:cont, [element2 | _] = list2_tail} ->
                index1 = Enum.find_index(reference_list, &(&1 == element1))
                index2 = Enum.find_index(reference_list, &(&1 == element2))

                case {index1, index2} do
                    {^index1, ^index2}                      -> {:cont, list2_tail}
                    {index1, index2} when index1 > index2   -> {:halt, true}
                    _                                       -> {:halt, false}
                end
            end) == {:halt, true}
        end)
    end
end


remap = %{"A" => "A", "K" => "B", "Q" => "C", "J" => "D", "T" => "E", "9" => "F", "8" => "G", "7" => "H", "6" => "I", "5" => "J", "4" => "K", "3" => "L", "2" => "M"}
order_map = %{"1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7,
              "A" => 19, "B" => 18, "C" => 17, "D" => 6, "E" => 15, "F" => 14, "G" => 13,
              "H" => 12, "I" => 11, "J" => 10, "K" => 9, "L" => 8, "M" => 7}

input = File.read!("day7_input.txt")
        |> String.split("\n")
        |> Enum.map(fn x -> String.split(x, " ") end)
        |> Enum.map(fn [h, t] -> {String.graphemes(h), t} end)
        |> Enum.map(fn {h, t} -> {Enum.map(h, fn x -> Map.fetch!(remap, x) end), t} end)

IO.inspect(Main.main(input, order_map), charlists: false)
