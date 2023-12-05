defmodule Main do

    def loop(game, map) do case game do
        [h | t] -> 
            [count, color] = String.split(h, " ")
            if map[color] >= String.to_integer(count) do
                Main.loop(t, map)
            else
                false
            end

        _ ->
            true
    end end

    
    def mainloop(input, map) do case input do
        [h | t] when t != []->
            game = String.replace(h, ~r/Game \d*: /, "")
            game = String.split(game, ~r/; |, /)
            [_, indx, _] = String.split(h, ~r/Game |: .*/, parts: 3)
            IO.inspect(indx)
            if Main.loop(game, map) == true do
                String.to_integer(indx) + Main.mainloop(t, map)
            else
                0 + Main.mainloop(t, map)
            end
            
        [h | _] ->
            game = String.replace(h, ~r/Game \d*: /, "")
            game = String.split(game, ~r/; |, /)
            [_, indx, _] = String.split(h, ~r/Game |: .*/, parts: 3)
            if Main.loop(game, map) == true do
                String.to_integer(indx)
            else
                0
            end

        _ -> 
            0
    end end

end

input = File.read!("day2_input.txt") 
input = String.split(input, "\n")

map = %{"red" => 12, "green" => 13, "blue" => 14}

IO.inspect(Main.mainloop(input, map))


