# Enum.at = nth
defmodule Keypad do
  def numberpad do
    # [[1,2,3],[4,5,6],[7,8,9]]
    [["0", "0", "1", "0", "0"], ["0", "2", "3", "4", "0"], ["5", "6", "7", "8", "9"], ["0", "A", "B", "C", "0"], ["0", "0", "D", "0", "0"]]
  end
  def canMove({x, y}) do
    Enum.at(Enum.at(numberpad, y), x) != "0"
  end
  def move(dir, {curX, curY}) do
    case dir do
      "L" -> if (curX > 0 and canMove({curX-1, curY})) do {curX-1, curY} else {curX, curY} end
      "R" -> if (curX < 4 and canMove({curX+1, curY})) do {curX+1, curY} else {curX, curY} end
      "U" -> if (curY > 0 and canMove({curX, curY-1})) do {curX, curY-1} else {curX, curY} end
      "D" -> if (curY < 4 and canMove({curX, curY+1})) do {curX, curY+1} else {curX, curY} end
    end
  end
  def newLoc(curLoc, moves) do
    Enum.reduce(moves, curLoc, &move(&1, &2))
  end
  def parseMoves(moves, {curCode, curLoc}) do
    {newX, newY} = newLoc(curLoc, moves)
    nextNum = Enum.at(Enum.at(numberpad, newY), newX)
    {curCode <> nextNum, {newX, newY}}
  end

  def parseInput(inst) do
    {code, _} = String.split(inst, "\n")
                |> Enum.map(fn line -> String.graphemes line end)
                |> Enum.reduce({"", {1,1}}, &parseMoves(&1, &2))
    code
  end

end

# acc = ("cur code", cur location)