require IEx
defmodule GridDistance do
  def add_coord({x1, y1}, {x2, y2}) do
    {x1+x2, y1+y2}
  end

  def dir_distance({x, y}, w) do
    {x*w, y*w}
  end

  def update_dir(nextMove, oldDir) do
    dir = String.at(nextMove, 0)
    case oldDir do
      {0, 1}  -> {if (dir == "L") do -1 else 1 end, 0}
      {0, -1} -> {if (dir == "L") do 1 else -1 end, 0}
      {1, 0}  -> {0, if (dir == "L") do 1 else -1 end}
      {-1, 0} -> {0, if (dir == "L") do -1 else 1 end}
    end
  end

  def walk(nextMove, {curDir, curLoc}) do
    distance = String.at(nextMove, 1)
    |> String.to_integer
    newDir = update_dir(nextMove, curDir)
    newLoc = 
      dir_distance(newDir, distance)
      |> add_coord(curLoc)
    # IEx.pry
    {newDir, newLoc}
  end

  def blocks_away(start, path) do
    {_, {dx, dy}} = Enum.reduce(path, {start, {0, 0}}, &walk(&1, &2))
    dx+dy
  end

  def main() do
    path = ["R4", "R1", "L2", "R1", "L1", "L1", "R1", "L5", "R1", "R5", "L2", "R3", "L3", "L4", "R4", "R4", "R3", "L5", "L1", "R5", "R3", "L4", "R1", "R5", "L1", "R3", "L2", "R3", "R1", "L4", "L1", "R1", "L1", "L5", "R1", "L2", "R2", "L3", "L5", "R1", "R5", "L1", "R188", "L3", "R2", "R52", "R5", "L3", "R79", "L1", "R5", "R186", "R2", "R1", "L3", "L5", "L2", "R2", "R4", "R5", "R5", "L5", "L4", "R5", "R3", "L4", "R4", "L4", "L4", "R5", "L4", "L3", "L1", "L4", "R1", "R2", "L5", "R3", "L4", "R3", "L3", "L5", "R1", "R1", "L3", "R2", "R1", "R2", "R2", "L4", "R5", "R1", "R3", "R2", "L2", "L2", "L1", "R2", "L1", "L3", "R5", "R1", "R4", "R5", "R2", "R2", "R4", "R4", "R1", "L3", "R4", "L2", "R2", "R1", "R3", "L5", "R5", "R2", "R5", "L1", "R2", "R4", "L1", "R5", "L3", "L3", "R1", "L4", "R2", "L2", "R1", "L1", "R4", "R3", "L2", "L3", "R3", "L2", "R1", "L4", "R5", "L1", "R5", "L2", "L1", "L5", "L2", "L5", "L2", "L4", "L2", "R3"]
    # path = [""R5"", ""L5"", ""R5"", ""R3""]
    start_face = {0, 1}
    blocks_away(start_face, path)
  end
end

# Input: List of turn...weight
# Start north
# North: (0, 1)
# South: (0, -1)
# East: (1, 0)
# West: (-1, 0)
# L: N-W-S-E
# R: N-E-S-W