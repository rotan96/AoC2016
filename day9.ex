require IEx
defmodule Decompress do
  def expand?(s), do: String.contains? s, "x"
  def combine(next, acc) do
    if expand?(next) do
      [count, reps, toExpand] = String.split(next, ["x", ")"], parts: 3)
      count = String.to_integer(count)
      # Subtract 1 from reps so we can append the reps to the string
      reps = String.to_integer(reps)-1 
      repeat = String.slice(toExpand, 0, count)
      acc <> String.duplicate(repeat, reps) <> toExpand
      # acc + ((String.length repeat) * reps) + (String.length toExpand)
    else
      acc <> next
      # acc + (String.length next)
    end
  end
  def expand(c) do
    if (Enum.count(c) == 1) do Enum.at(c, 0)
    else
      List.foldl(c, "", &combine(&1, &2))
    end
  end
  def part1 do
    {:ok, lines} = File.read "day9.txt"
    # lines = "ADVENTA(1x5)BC(3x3)XYZA(2x2)BCD(2x2)EFG(6x1)(1x3)AX(8x2)(3x3)ABCY"
    # lines = "(10x14)(7x7)"
    String.trim(lines)
    |> String.split(~r{(?<!\))[(]})
    |> expand
    |> String.length
    # |> Enum.map(fn x -> String.length(x) end)
    # |> Enum.sum
  end
end