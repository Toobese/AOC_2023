input = File.read!("day1_input.txt") 
input = String.split(input, "\n")
numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

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


    def mainloop(input, numbers) do
        case input do

            [h | t] when t != [] -> 
                {_, left} = Main.loop2(h, numbers)
                {_, right} = Main.loop2(String.reverse(h), numbers)
                String.to_integer("#{left}#{right}") + Main.mainloop(t, numbers)
            
            [h | _] -> 
                {_, left} = Main.loop2(h, numbers)
                {_, right} = Main.loop2(String.reverse(h), numbers)
                String.to_integer("#{left}#{right}")

            _ ->
                IO.inspect("dead")
        end
    end
end

IO.inspect(Main.mainloop(input, numbers))