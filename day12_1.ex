defmodule Main do
   def main(path) do
      input = File.read!(path) |> String.split("\n")
      symbol_rows = input |> Enum.map(fn x -> hd(String.split(x, " ")) |> String.graphemes end)
      number_rows = input |> Enum.map(fn x -> hd(tl(String.split(x, " "))) |> String.split(",") |> Enum.map(&String.to_integer/1) end)
      one_rows = Enum.map(symbol_rows, fn x -> [1] ++ Enum.map(1..length(x)-1, fn _ -> 0 end) end)

      Enum.map(Enum.zip([symbol_rows, number_rows, one_rows]), fn {symbols_line, numbers_line, ones_line} ->
         [sy, va] = Enum.reduce(numbers_line, [symbols_line, ones_line], fn number, [symbols, values] ->
            [s, v, _c, _d, _r] = Main.step(symbols, values, number)
            [s, v]

         end)
         stacked_s = sy ++ Enum.map(1..length(va)-length(sy), fn _ -> "." end)
         Enum.reduce_while(Enum.zip(stacked_s, va), 0 , fn {a, b}, acc -> case a do
               "#" -> {:cont, 0}
               _   -> {:cont, acc + b}
            end end)
         |> IO.inspect()


      end)
      |> Enum.sum()
   end

   def step(symbols, values, number) do
      Enum.reduce_while(Enum.zip([symbols, values]), [[], [], 0, 0, true], fn {sym, val}, [symbs, vals, carry, index, first] ->
         start_val = val + carry
         case sym do
            "." -> case first do
                     true  -> {:cont, [symbs, vals, start_val, index + 1, first]}
                     false -> {:cont, [symbs, vals ++ [0], start_val, index + 1, first]}
                  end

            "?" -> case [Main.is_allowed(Enum.slice(symbols, index, number + 1), number), first] do
                     [true, true]   -> {:cont, [Enum.slice(symbols, index + number + 1, length(symbols)), vals++[start_val], start_val, index + 1, false]}
                     [true, false]  -> {:cont, [symbs, vals ++ [start_val], start_val, index + 1, first]}
                     [false, true]  -> {:cont, [symbs, vals, start_val, index + 1, first]}
                     [false, false] -> {:cont, [symbs, vals ++ [0], start_val, index + 1, first]}
                  end

            "#" -> case [Main.is_allowed(Enum.slice(symbols, index, number + 1), number), first] do
                     [true, true]   -> {:cont, [Enum.slice(symbols, index + number + 1, length(symbols)), vals++[start_val], 0, index + 1, false]}
                     [true, false]  -> {:cont, [symbs, vals ++ [start_val], 0, index + 1, first]}
                     [false, true]  -> {:cont, [symbs, vals, 0, index + 1, first]}
                     [false, false] -> {:cont, [symbs, vals ++ [0], 0, index + 1, first]}
                  end
               end
      end)
   end

   def is_allowed(symbols, number) do case String.length("#{symbols}") do
      ^number -> Regex.compile!("[?|#]{#{number}}[.|?]") |> Regex.match?("#{symbols}"<>".")
      _rest   -> Regex.compile!("[?|#]{#{number}}[.|?]") |> Regex.match?("#{symbols}")
   end end
end

IO.inspect(Main.main("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt"))
