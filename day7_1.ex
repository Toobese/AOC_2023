defmodule Main do
  import Logger

  def main(path) do
    path
    |> handle_input()
    |> Enum.reduce(0, fn line, acc ->
      acc + handle_line(line)
    end)
    |> IO.inspect()
  end

  def handle_input(path) do
    path
    |> File.read!()
    |> String.split("\n")
  end

  def handle_line(line) do
    [goal, values] = String.split(line, ": ")

    numbers =
      String.split(values, " ")
      |> Enum.map(&String.to_integer/1)

    [first, second | rest] = numbers

    cond do
      length(rest) == 0 ->
        if first + second == String.to_integer(goal) or first * second == String.to_integer(goal) do
          String.to_integer(goal)
        else
          0
        end

      handle_calc(String.to_integer(goal), first + second, hd(rest), tl(rest)) ->
        String.to_integer(goal)

      handle_calc(String.to_integer(goal), first * second, hd(rest), tl(rest)) ->
        String.to_integer(goal)

      true ->
        0
    end
  end

  def handle_calc(goal, current, head, []) do
    current + head == goal or current * head == goal
  end

  def handle_calc(goal, current, head, rest) do
    handle_calc(goal, current + head, hd(rest), tl(rest)) or
      handle_calc(goal, current * head, hd(rest), tl(rest))
  end
end

Main.main("day" <> String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "") <> "_input.txt")
