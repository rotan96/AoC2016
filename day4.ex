require IEx

defmodule ValidRooms do
  def incrCount(letter, seen) do
    Map.update(seen, letter, 1, &(&1+1))
  end
  def countLetters(s) do
    String.graphemes(s)
    |> Enum.reduce(Map.new, &incrCount(&1, &2))
  end
  def getLetters(chunks) do
    Enum.slice(chunks, 0..Enum.count(chunks)-2)
    |> List.foldr("", &(&1 <> &2))
    |> countLetters
  end
  def shift(x, shiftAmt) do
    if (x == "-") do
      32 #value for space
    else
      <<aacute::utf8>> = x
      newLetter = aacute + shiftAmt
      if (newLetter > 122) do
        newLetter - 26
      else
        newLetter
      end
    end
  end
  def decrypt(s) do
    chunks = String.split(s, "-")
    [id, _] = List.last(chunks)
    |> String.split("[")
    shiftAmt = rem(String.to_integer(id), 26)
    shifted = Enum.slice(chunks, 0..Enum.count(chunks)-2)
    |> List.foldr("", &(&1 <> &2))
    |> String.graphemes
    |> Enum.map(fn(x) -> shift(x, shiftAmt) end)
    {shifted, id}
  end
  def realRoom(letterCount, checksum) do
    {order, _, _} = String.graphemes(checksum)
    |> List.foldr({true, 0, [0]}, 
                  fn(x, {valid, curMin, prevLetter}) ->
                    curCount = Map.get(letterCount, x, 0)
                    cond do
                      curCount > curMin ->
                        {true and valid, curCount, x}
                      curCount == curMin ->
                        {prevLetter > x and valid, curCount, x}
                      curCount < curMin ->
                        {false, curCount, x}
                    end
                  end)
    order
  end
  def isValid(s) do
    chunks = String.split(s, "-")
    [id, checksum, _] = List.last(chunks)
    |> String.split(["[", "]"])
    getLetters(chunks)
    |> realRoom(checksum)
  end
  def getValidID(s) do
    if isValid(s) do
      chunks = String.split(s, "-")
      [id, _, _] = List.last(chunks)
      String.to_integer(id)
    else
      0
    end
  end
  def checkRooms(s) do
    String.split(s, "\n")
    |> Enum.map(fn(x) -> getValidID(x) end)
    |> Enum.reduce(fn(x, acc) -> x + acc end)
  end
  def part1() do
    {:ok, rooms} = File.read "day4.txt"
    checkRooms(rooms)
  end
  def part2() do
    {:ok, rooms} = File.read "day4.txt"
    String.split(rooms, "\n")
    |> Enum.filter(fn(x) -> isValid(x) end)
    |> Enum.map(fn(x) -> decrypt(x) end)
    |> Enum.filter(fn({name, _}) -> List.first(name) == 110 end) 
  end
end