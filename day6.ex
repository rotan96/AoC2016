require IEx
defmodule FreqLetters do
  def groupLetters(letters, curMap) do
    # IEx.pry
    Enum.with_index(letters)
    |> List.foldl(curMap, fn ({l, i}, m) -> 
                            Map.update(m, i, l,
                              fn cur -> 
                                (cur <> l) end) end)
  end
  def incrCount(letter, seen) do
    Map.update(seen, letter, 1, &(&1+1))
  end
  def mostSeen({_, letters}) do
    String.graphemes(letters)
    |> Enum.reduce(Map.new, &incrCount(&1, &2))
    |> Map.to_list
    |> Enum.max_by(fn({_, count}) -> count end)
    |> elem(0)
  end
  def leastSeen({_, letters}) do
    String.graphemes(letters)
    |> Enum.reduce(Map.new, &incrCount(&1, &2))
    |> Map.to_list
    |> Enum.min_by(fn({_, count}) -> count end)
    |> elem(0)
  end
  def splitCols(s) do
    String.split(s, "\n")
    |> Enum.map(&String.graphemes(&1))
    |> List.foldl(Map.new, &groupLetters(&1, &2))
    |> Map.to_list
  end
  def part1() do
    {:ok, message} = File.read "day6.txt"
    splitCols(message)
    |> Enum.map(&mostSeen(&1))
    |> Enum.join
  end
  def part2() do
    {:ok, message} = File.read "day6.txt"
    splitCols(message)
    |> Enum.map(&leastSeen(&1))
    |> Enum.join
  end
end