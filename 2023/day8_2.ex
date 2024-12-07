defmodule Main do
    def main(directions, start, map) do
        cycle_through_directions(directions, start, map, 0)
    end

    defp cycle_through_directions(directions, key, map, steps) do
        direction = Enum.at(directions, rem(steps, length(directions)))

        if elem(Map.fetch!(map, key), direction) |> Atom.to_string()|> String.ends_with?("Z") do
            steps + 1
        else
            new_key = elem(Map.fetch!(map, key), direction)
            cycle_through_directions(directions, new_key, map, steps + 1)
        end
    end
end

defmodule BasicMath do
	def gcd(a, 0), do: a
	def gcd(0, b), do: b
	def gcd(a, b), do: gcd(b, rem(a,b))

	def lcm(0, 0), do: 0
	def lcm(a, b), do: (a*b)/gcd(a,b)
end



directions = hd(File.read!("day8_input.txt")
            |> String.split("\n"))
            |> String.graphemes
            |> Enum.map(fn x -> if x == "L", do: 0, else: 1 end)

starts =  Enum.reduce(tl(File.read!("day8_input.txt")
            |> String.split("\n")), [], fn x, acc ->
                case Regex.match?(~r/[A-Z]+A = \([A-Z]*, [A-Z]*\)/, x) do
                    true -> [String.to_atom(String.replace(x, ~r/ = \([A-Z]*, [A-Z]*\)/, ""))] ++ acc
                    false -> acc
                end
            end)

map =   Enum.reduce(tl(File.read!("day8_input.txt")
        |> String.split("\n")), %{}, fn x, acc ->
            Map.put(acc, String.to_atom(String.replace(x, ~r/ = \([A-Z]*, [A-Z]*\)/, "")), String.replace(x, ~r/[A-Z]* = \(|\)/, "")
            |> String.split(", ")
            |> Enum.map(&String.to_atom/1)
            |> List.to_tuple())
        end)

routes = Enum.map(starts, fn x -> Main.main(directions, x, map) end)
Enum.reduce(routes, hd(routes), fn x, acc -> trunc(BasicMath.lcm(acc, x)) end) |> IO.inspect()
