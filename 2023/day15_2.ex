defmodule Main do
   def main(input, boxes) do case String.match?(input, ~r/[a-z]*=\d*/) do
      true  -> Main.add_lens(String.split(input, ~r/=/), Main.do_eql(input), boxes)
      false -> Main.remove_lens(String.split(input, "-") |> hd(), Main.do_min(input), boxes)
   end end

   def add_lens([box_name, lens], box_number, boxes) do case Map.has_key?(boxes, box_number) do
      true  -> case Map.has_key?(Map.fetch!(boxes, box_number), box_name) do
                  true  ->
                     [index, name, _old_lens] = Map.fetch!(Map.fetch!(boxes, box_number), box_name)
                     Map.replace(boxes, box_number, Map.put(Map.fetch!(boxes, box_number), box_name, [index, name, lens]))
                  false -> case length(Map.to_list(Map.fetch!(boxes, box_number))) do
                     0   -> Map.replace(boxes, box_number, Map.put_new(Map.fetch!(boxes, box_number), box_name, [0, box_name, lens]))

                     _df ->
                        new_index = Map.values(Map.fetch!(boxes, box_number)) |> Enum.sort() |> Enum.reverse() |> hd() |> hd()
                        Map.replace(boxes, box_number, Map.put_new(Map.fetch!(boxes, box_number), box_name, [new_index + 1, box_name, lens]))
                  end end
      false -> Map.put_new(boxes, box_number, %{box_name => [0, box_name, lens]})
   end end

   def remove_lens(box_name, box_number, boxes)do case Map.has_key?(boxes, box_number) do
      true  -> case Map.has_key?(Map.fetch!(boxes, box_number), box_name) do
                  true  -> Map.replace(boxes, box_number, Map.delete(Map.fetch!(boxes, box_number), box_name))
                  false -> boxes
               end
      false -> boxes
   end end

   def do_min(input), do: String.split(input, "-")   |> hd() |> String.to_charlist() |> Enum.reduce(0, fn x, acc -> rem((acc + x) * 17, 256) end)
   def do_eql(input), do: String.split(input, ~r/=/) |> hd() |> String.to_charlist() |> Enum.reduce(0, fn x, acc -> rem((acc + x) * 17, 256) end)
end

File.read!("day"<>String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "")<>"_input.txt")
|> String.split(",")|> Enum.reduce(%{}, fn x, boxes -> Main.main(x, boxes) end)
|> Enum.reduce(0, fn {key, values}, acc ->
      new_values = values |> Map.values() |> Enum.sort()
      |> Enum.reduce([0, 1], fn [_index, _name, lens], [acc2, ind] -> [acc2 + ((key + 1) * ind) * String.to_integer(lens), ind + 1] end) |> hd()
      new_values + acc
   end)
|> IO.inspect()
