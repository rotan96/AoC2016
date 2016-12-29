defmodule Robot do
  # def move({dx, dy}, )
  def part1() do
    # Must visit numbers 0-7
    {:ok, maze} = File.read "day24.txt"
    start = {153,10}
    String.split(maze, "\n")
  end
end