defmodule Main do

    def main(winners, tickets) do case [winners, tickets] do
        [[h | t], [h2 | t2]] ->
            intersect = MapSet.intersection(h, h2)

            case MapSet.size(intersect) do
                0 -> Main.main(t, t2)
                x -> 2**(x-1) + Main.main(t, t2)
            end

        [[], []] -> 0
    end end

end

input = File.read!("day4_input.txt") 
input = String.split(input, "\n")

cards = for game <- input do String.replace(String.replace(game, ~r/Card +\d*: /, ""), ~r/ +/, " ") end

winning_strings = for card <- cards do String.replace_leading(String.replace(card, ~r/ \|( \d+)+/, ""), " ", "") end
tickets_strings = for card <- cards do String.replace_leading(String.replace(card, ~r/(\d+ )+\| /, ""), " ", "") end

winning = for winning_string <- winning_strings do String.split(winning_string, ~r/ /) end
tickets = for tickets_string <- tickets_strings do String.split(tickets_string, ~r/ /) end

winning_map = for winner <- winning do MapSet.new(winner) end
tickets_map = for ticket <- tickets do MapSet.new(ticket) end

IO.inspect(Main.main(winning_map, tickets_map))