defmodule Main do

    def main(map, numbers, column, width, height) do
        if column == height do
            0
        else
            Main.loop(map, 1, column, numbers, width) + Main.main(map, numbers, column + 1, width, height)
        end
    end


    def loop(map, row, column, numbers, width) do

        if width == row do
            0
        else 
            current = elem(elem(map, column), row)

            if current == "*" do
                Main.create_neighbours(map, row, column, numbers) + Main.loop(map, row + 1, column, numbers, width)
            else
                Main.loop(map, row + 1, column, numbers, width)
            end
        end
    end


    def create_neighbours(map, row, column, numbers) do
        top = Enum.slice(Tuple.to_list(elem(map, column - 1)), (row - 1)..(row + 1))
        left = Enum.slice(Tuple.to_list(elem(map, column)), (row - 1)..(row - 1))
        right = Enum.slice(Tuple.to_list(elem(map, column)), (row + 1)..(row + 1))
        bottom = Enum.slice(Tuple.to_list(elem(map, column + 1)), (row - 1)..(row + 1))

        n_top = Main.check_touching_tb(top, numbers)
        n_bottom = Main.check_touching_tb(bottom, numbers)
        n_left = Main.check_touching_lr(left, numbers)
        n_right = Main.check_touching_lr(right, numbers) 

        n_touching = n_top + n_bottom + n_left + n_right
        
        if n_touching == 2 do

            case [n_top, n_bottom, n_left, n_right] do
                [0, 0, 1, 1] ->
                    i_left = Main.find_left(map, row - 1, column, numbers)
                    String.to_integer(Main.get_number(map, i_left, column, numbers)) * String.to_integer(Main.get_number(map, row + 1, column, numbers))
                    
                [1, 1, 0, 0] ->
                    i_top = Main.find_left(map, Main.find_random(map, row - 1, column - 1, numbers), column - 1, numbers)
                    i_bottom = Main.find_left(map, Main.find_random(map, row - 1, column + 1, numbers), column + 1, numbers)
                    String.to_integer(Main.get_number(map, i_top, column - 1, numbers)) * String.to_integer(Main.get_number(map, i_bottom, column + 1, numbers))

                [2, 0, 0, 0] ->
                    i_left = Main.find_left(map, row - 1, column - 1, numbers)
                    String.to_integer(Main.get_number(map, i_left, column - 1, numbers)) * String.to_integer(Main.get_number(map, row + 1, column - 1, numbers))

                [0, 2, 0, 0] ->
                    i_left = Main.find_left(map, row - 1, column + 1, numbers)
                    String.to_integer(Main.get_number(map, i_left, column + 1, numbers)) * String.to_integer(Main.get_number(map, row + 1, column + 1, numbers))

                [1, 0, 1, 0] ->
                    i_top = Main.find_left(map, Main.find_random(map, row - 1, column - 1, numbers), column - 1, numbers)
                    i_left = Main.find_left(map, row - 1, column, numbers)
                    String.to_integer(Main.get_number(map, i_left, column, numbers)) * String.to_integer(Main.get_number(map, i_top, column - 1, numbers))

                [1, 0, 0, 1] ->
                    i_top = Main.find_left(map, Main.find_random(map, row - 1, column - 1, numbers), column - 1, numbers)
                    String.to_integer(Main.get_number(map, i_top, column - 1, numbers)) * String.to_integer(Main.get_number(map, row + 1, column, numbers))

                [0, 1, 1, 0] ->
                    i_bottom = Main.find_left(map, Main.find_random(map, row - 1, column + 1, numbers), column + 1, numbers)
                    i_left = Main.find_left(map, row - 1, column, numbers)
                    String.to_integer(Main.get_number(map, i_left, column, numbers)) * String.to_integer(Main.get_number(map, i_bottom, column + 1, numbers))

                [0, 1, 0, 1] ->
                    i_bottom = Main.find_left(map, Main.find_random(map, row - 1, column + 1, numbers), column + 1, numbers)
                    String.to_integer(Main.get_number(map, i_bottom, column + 1, numbers)) * String.to_integer(Main.get_number(map, row + 1, column, numbers))
            end
        else
            0
        end
    end


    def find_random(map, row, column, numbers) do
        current = elem(elem(map, column), row)

        if Enum.member?(numbers, "#{current}") do
            Main.find_left(map, row, column, numbers)
        else
            Main.find_random(map, row+1, column, numbers)
        end
    end


    def find_left(map, row, column, numbers) do
        current = elem(elem(map, column), row)

        if Enum.member?(numbers, "#{current}") do
            Main.find_left(map, row - 1, column, numbers)
        else
            row + 1
        end
    end


    def check_touching_tb(neighbours, numbers) do 
        new_neighbours = List.to_tuple(neighbours)
        store = [Enum.member?(numbers, elem(new_neighbours, 0)), 
                 Enum.member?(numbers, elem(new_neighbours, 1)), 
                 Enum.member?(numbers, elem(new_neighbours, 2))]

        case store do
            [true, false, true] -> 2
            [false, false, false] -> 0
            [_, _, _] -> 1
        end
    end


    def check_touching_lr(neighbours, numbers) do 
        new_neighbours = List.to_tuple(neighbours)
        if Enum.member?(numbers, elem(new_neighbours, 0)) do
            1
        else
            0
        end
    end


    def get_number(map, row, column, numbers) do
        current = elem(elem(map, column), row)

        if Enum.member?(numbers, "#{current}") do
            "#{current}#{Main.get_number(map, row+1, column, numbers)}"
        else
            ""
        end
    end

end

input = File.read!("day3_input.txt") 
input = String.split(input, "\n")
numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
width = length(String.split(hd(input), "")) - 1
height = length(input) - 1


save = for item <- input do List.to_tuple(String.split(item, "")) end
map = List.to_tuple(save)

IO.inspect(Main.main(map, numbers, 1, width, height))
