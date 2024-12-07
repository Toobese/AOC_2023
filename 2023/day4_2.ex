defmodule Main do

    def main(cards) do case cards do
        [h | t] ->
            win = elem(elem(h, 0), 0)
            tick = elem(elem(h, 0), 1)
            intersect = MapSet.intersection(win, tick)
            tail = Main.update_tail(t, MapSet.size(intersect), elem(h, 1))
            elem(h, 1) + Main.main(tail)
        [] -> 0
    end end

    def update_tail(tail, length, n_tickets) do case [tail, length] do
        [z, 0] -> z
        [[h | t], x] -> [{elem(h, 0), elem(h, 1) + 1 * n_tickets}]++Main.update_tail(t, x - 1, n_tickets)
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

store3 = Enum.zip(winning_map, tickets_map)

setup_cards = for card <- store3 do {card, 1} end
IO.inspect(Main.main(setup_cards))
