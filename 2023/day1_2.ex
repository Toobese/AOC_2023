input = File.read!("day1_input.txt") 
input = String.split(input, "\n")
numbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
numbers_r = ["orez", "eno", "owt", "eerht", "ruof", "evif", "xis", "neves", "thgie", "enin", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
map = %{"zero" => "0", "one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9", 
        "0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5", "6" => "6", "7" => "7", "8" => "8", "9" => "9"}

defmodule Main do

    def loop(testword, check) do
        if(String.contains?(testword, check)) do
            [left, _] = String.split(testword, check, parts: 2)
            {String.length(left), check}
        else
            {nil, check}
        end
    end


    def loop2(testword, checks) do
        case checks do
        
            [h | t] when t != [] -> 
                current = Main.loop(testword, h)
                lowest = Main.loop2(testword, t)
                if elem(current, 0) < elem(lowest, 0), do: current, else: lowest
            
            [h | _] ->
                Main.loop(testword, h)
            
            _ ->
                IO.inspect("An illegal case has been found in loop2")
        
        end
    end


    def mainloop(input, numbers, numbers_r, map) do
        case input do

            [h | t] when t != [] -> 
                {_, left} = Main.loop2(h, numbers)
                {_, right} = Main.loop2(String.reverse(h), numbers_r)
                String.to_integer("#{map[left]}#{map[String.reverse(right)]}") + Main.mainloop(t, numbers, numbers_r, map)
            
            [h | _] -> 
                {_, left} = Main.loop2(h, numbers)
                {_, right} = Main.loop2(String.reverse(h), numbers_r)
                String.to_integer("#{map[left]}#{map[String.reverse(right)]}")

            _ ->
                IO.inspect("dead")
        end
    end
end

IO.inspect(Main.mainloop(input, numbers, numbers_r, map))