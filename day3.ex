require IEx

defmodule ValidTriangle do
  def isTriangle(t) do
    # IEx.pry
    if (Enum.count(t) == 3) do
      [a, b, c] = Enum.map(t, fn e -> String.to_integer(e) end) |> Enum.sort(&(&1 < &2))
      # IEx.pry
      if (a + b > c) do 1 else 0 end
    else
      0
    end
  end
  def parseInput(triangles) do
    String.split(triangles, "\n")
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.map(fn t -> Enum.filter(t, fn x -> x != "" end) end)
    |> Enum.map(&isTriangle(&1))
    |> Enum.reduce(0, fn(x, acc) -> x + acc end)
  end
end