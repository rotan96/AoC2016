defmodule HashDoor do
  def id do
    "cxdnnyjw"
  end
  def hash(s) do
    :crypto.hash(:md5, s)
    |> Base.encode16
  end
  def getCode(i) do
    h = hash(id <> Integer.to_string(i))
    if (String.slice(h, 0, 5) == "00000") do
      {h, i}
    else
      getCode(i+1)
    end
  end
  def buildPass1({pass, i}) do
    if (String.length(pass) < 8) do
      {h, i} = getCode(i)
      nextLetter = String.at(h, 5)
      buildPass1({pass <> nextLetter, i+1})
    else
      pass
    end
  end
  def blank(pass) do
    List.foldl(pass, false, fn({_, s}, blankSeen) -> blankSeen or s == "" end)
  end
  def newInd(i, pass) do
    Enum.at(pass, i) == {i, ""}
  end
  def buildPass2({pass, i}) do
    if blank(pass) do
      {h, i} = getCode(i)
      letterInd = String.at(h, 5) |>
        String.to_integer(36)
      if (letterInd < 8 and newInd(letterInd, pass)) do
        nextLetter = String.at(h, 6)
        newPass = List.keyreplace(pass, letterInd, 0, {letterInd, nextLetter})
        buildPass2({newPass, i+1})
      else
        buildPass2({pass, i+1})
      end
    else
      pass
    end
  end
  def part1 do
    buildPass1({"", 0})
  end
  def part2 do
    buildPass2({[{0, ""}, {1, ""}, {2, ""}, {3, ""},
                 {4, ""}, {5, ""}, {6, ""}, {7, ""}], 0})
    |> Enum.map(fn {_, l} -> l end)
    |> Enum.join
  end
end