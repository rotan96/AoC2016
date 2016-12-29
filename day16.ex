require IEx
defmodule ModifyData do
  def flip_bits(a) do
    String.reverse(a)
    |> String.graphemes
    |> Enum.map(fn (b) -> if (b == "1") do "0" else "1" end end)
    |> List.to_string
  end

  def generate_data(state) do
    state <> "0" <> flip_bits(state)
  end

  def checksum(data) do
    if (rem(Enum.count(data), 2) == 1) do
      data
    else
      Enum.chunk(data, 2)
      |> Enum.map(fn ([a,b]) -> if (a == b) do  "1" else "0" end end)
      |> checksum
    end
  end

  def fill(state, target_len) do
    if (String.length(state) >= target_len) do
      String.slice(state, 0, target_len)
      |> String.graphemes
      |> checksum
    else
      generate_data(state)
      |> fill(target_len)
    end
  end

  def main() do
    init_state = "01110110101001000"
    len = 10
    fill(init_state, len)
    |> List.to_string
  end
end