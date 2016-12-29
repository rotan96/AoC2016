defmodule IPVCheck do
  def countBools(bList) do
    Enum.filter(bList, fn x -> x end)
    |> Enum.count
  end
  def flip(s) do
    String.graphemes(s)
    |> Enum.reverse
    |> List.foldl("", fn(x, acc) -> acc <> x end)
  end
  def isABBA(s) do
    midpoint = round(String.length(s)/2)
    {front, back} = String.split_at(s, midpoint)
    (front == flip(back) and (String.at(front, 0) != String.at(front, 1)))
  end
  # Gets elems outside brackets
  def getOutside(s) do
    String.split(s, ~r{\[[a-z]+\]})
  end
  # Gets elems inside brackets
  def getInside({s, outside}) do
    String.split(s, ["[", "]"]) -- outside
  end
  def abba?(s) do
    if (String.length(s) < 4) do false
    else
      isABBA(String.slice(s, 0, 4)) or abba?(String.slice(s, 1..-1))
    end
  end
  def supportTLS({inside, outside}) do
    insidePal = Enum.map(inside, &abba?(&1))
    |> countBools
    if (insidePal > 0) do
      false
    else
      outsidePal = Enum.map(outside, &abba?(&1))
      |> countBools
      outsidePal > 0
    end
  end
  def isABA(s) do
    (String.at(s, 0) == String.at(s, 2)) and
    (String.at(s, 0) != String.at(s, 1))
  end
  def getABA(s, cur) do
    if (String.length(s) < 3) do cur
    else
      sub = String.slice(s, 0, 3)
      rest = String.slice(s, 1..-1)
      if (isABA(sub)) do getABA(rest, Enum.concat(cur, [sub]))
      else getABA(rest, cur)
      end
    end
  end
  def flipBAB(s) do
    String.at(s, 1) <> String.at(s, 0) <> String.at(s, 1)
  end
  def containsBAB(inside, abas) do
    if (String.length(inside) < 3) do false
    else 
      sub = String.slice(inside, 0, 3)
      rest = String.slice(inside, 1..-1)
      (Enum.member?(abas, flipBAB(sub)) and isABA(sub))
      or containsBAB(rest, abas)
    end
  end
  def supportSSL({inside, outside}) do
    abas = List.foldl(outside, [], &getABA(&1, &2))
    List.foldl(inside, false,
      fn(inner, seen) ->
        seen or
        containsBAB(inner, abas) end)
  end
  def setup(s) do
    listInput = String.split(s, "\n")
    outside = Enum.map(listInput, &getOutside(&1))
    inside = List.zip([listInput, outside])
    |> Enum.map(&getInside(&1))
    List.zip([inside, outside])
  end
  def part1 do
    {:ok, ip} = File.read "day7.txt"
    setup(ip)
    |> Enum.map(&supportTLS(&1))
    |> countBools
  end
  def part2 do
    {:ok, ip} = File.read "day7.txt"
    setup(ip)
    |> Enum.map(&supportSSL(&1))
    |> countBools
  end
end