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
    real_goal = String.to_integer(goal)

    numbers =
      String.split(values, " ")
      |> Enum.map(&String.to_integer/1)

    [first, second | rest] = numbers

    cond do
      length(rest) == 0 ->
        if first + second == real_goal or first * second == real_goal or
             concatenate(first, second) == real_goal do
          real_goal
        else
          0
        end

      handle_calc(real_goal, first + second, hd(rest), tl(rest)) ->
        real_goal

      handle_calc(real_goal, first * second, hd(rest), tl(rest)) ->
        real_goal

      handle_calc(real_goal, concatenate(first, second), hd(rest), tl(rest)) ->
        real_goal

      true ->
        0
    end
  end

  def handle_calc(goal, current, head, []) do
    current + head == goal or current * head == goal or concatenate(current, head) == goal
  end

  def handle_calc(goal, current, head, rest) do
    handle_calc(goal, current + head, hd(rest), tl(rest)) or
      handle_calc(goal, current * head, hd(rest), tl(rest)) or
      handle_calc(goal, concatenate(current, head), hd(rest), tl(rest))
  end

  def concatenate(left, right) do
    String.to_integer(Integer.to_string(left) <> Integer.to_string(right))
  end
end

Main.main("day" <> String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "") <> "_input.txt")
