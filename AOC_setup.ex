defmodule Main do
  def main(path) do
    map = Main.handle_input(path)
  end

  def handle_input(path) do
    path
    |> File.read!()
    |> String.split("\n")
  end
end

IO.inspect(
  Main.main("day" <> String.replace(__ENV__.file, ~r/[\s\S]*\/day|_\d.ex/, "") <> "_input.txt")
)
