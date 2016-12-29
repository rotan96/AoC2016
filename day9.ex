defmodule Decompress do
  def part1 do
    # {:ok, lines} = File.read "day7.txt"
    lines = "ADVENT
A(1X5)BC
(3X3)XYZ
A(2X2)BCD(2X2)EFG
(6X1)(1X3)A
X(8X2)(3X3)ABCY"
    String.split(lines, "\n")
    |> Enum.map(fn s -> String.split(s, ["(", ")"]) end)
  end
end