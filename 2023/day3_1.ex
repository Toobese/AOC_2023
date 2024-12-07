defmodule Main do

    def main(map, incorrect, column, width, height) do
        if column == height do
            0
        else
            Main.loop(map, 1, column, incorrect, width) + Main.main(map, incorrect, column + 1, width, height)
        end
    end


    def loop(map, row, column, incorrect, width) do

        if width == row do
            0
        else 
            current = elem(elem(map, column), row)

            if Enum.member?(incorrect, "#{current}") and "#{current}" != "." and "#{current}" != "" do
                number = Main.get_number(map, row, column, incorrect)
                skip = String.length(number)
                neighbours = Main.create_neighbours(map, row, column, skip)
                counts = Main.check_number(neighbours, incorrect)

                if counts do
                    String.to_integer(number) + Main.loop(map, row+skip, column, incorrect, width)
                else
                    Main.loop(map, row+skip, column, incorrect, width)
                end
            else
                Main.loop(map, row+1, column, incorrect, width)
            end
        end
    end


    def create_neighbours(map, row, column, length) do
        top = Enum.slice(Tuple.to_list(elem(map, column - 1)), (row - 1)..(row + length))
        left = Enum.slice(Tuple.to_list(elem(map, column)), (row - 1)..(row - 1))
        right = Enum.slice(Tuple.to_list(elem(map, column)), (row + length)..(row + length))
        bottom = Enum.slice(Tuple.to_list(elem(map, column + 1)), (row - 1)..(row + length))
        left++right++bottom++top
    end


    def check_number(neighbours, incorrect) do case neighbours do
        [h | t] ->
            if Enum.member?(incorrect, "#{h}") == true do
                Main.check_number(t, incorrect)
            else
                true
            end
        
        [] -> false
    end end

    def get_number(map, row, column, incorrect) do
        current = elem(elem(map, column), row)

        if Enum.member?(incorrect, "#{current}") and "#{current}" != "." and "#{current}" != "" do
            "#{current}#{Main.get_number(map, row+1, column, incorrect)}"
        else
            ""
        end
    end

end

input = File.read!("day3_input.txt") 
input = String.split(input, "\n")
incorrect = [".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ""]
width = length(String.split(hd(input), "")) - 1
height = length(input) - 1


save = for item <- input do List.to_tuple(String.split(item, "")) end
map = List.to_tuple(save)

IO.inspect(Main.main(map, incorrect, 1, width, height))
