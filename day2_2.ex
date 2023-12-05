defmodule Main do

    def loop(game, map) do 
        case game do
            [h | t] -> 
                [count_str, color] = String.split(h, " ")
                count = String.to_integer(count_str)

                m = case map[color] do

                        nil -> 
                            Map.put(map, color, count)
                        
                        old_count when count > old_count ->
                            Map.put(map, color, count)

                        _ -> map
                    end
                Main.loop(t, m)

            [] -> map
        end
    end

    
    def mainloop(input, map) do 
        case input do
            [h | t] ->
                game = String.replace(h, ~r/Game \d*: /, "")
                game = String.split(game, ~r/; |, /)
                min_set = Main.loop(game, map)
                answer = min_set["blue"] * min_set["green"] * min_set["red"]
                answer + Main.mainloop(t, map)
                
            [] -> 0
        end 
    end

end

input = File.read!("day2_input.txt") 
input = String.split(input, "\n")
map = %{"red" => nil, "green" => nil, "blue" => nil}

IO.inspect(Main.mainloop(input, map))


