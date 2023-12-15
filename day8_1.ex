directions = hd(File.read!("day8_input.txt")
            |> String.split("\n"))
            |> String.graphemes
            |> Enum.map(fn x -> if x == "L", do: 0, else: 1 end)
            |> (fn list -> Enum.concat(for _ <- 1..1000, do: list) end).()

map =   Enum.reduce(tl(File.read!("day8_input.txt")
        |> String.split("\n")), %{}, fn x, acc ->
            Map.put(acc, String.to_atom(String.replace(x, ~r/ = \([A-Z]*, [A-Z]*\)/, "")), String.replace(x, ~r/[A-Z]* = \(|\)/, "")
            |> String.split(", ")
            |> Enum.map(&String.to_atom/1)
            |> List.to_tuple())
        end)

IO.inspect(elem(Enum.reduce_while(directions, {:AAA, 0}, fn dir, {key, steps} ->
    if elem(Map.fetch!(map, key), dir) == :ZZZ do
        {:halt, {key, steps + 1}}
    else
        {:cont, {elem(Map.fetch!(map, key), dir), steps + 1}}
    end end), 1))
