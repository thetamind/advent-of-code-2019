defmodule Computer.Day09Test do
  use ExUnit.Case, async: true

  doctest Computer.Day09

  test "part 1 solution" do
    input = File.read!("data/day09.txt")
    assert Computer.Day09.part1(input) == [-1]
  end

  test "write with upper memory area supper " do
    assert {[0, 1, 99, 3], _uma} = Computer.write([0, 1, 2, 3], %{}, 0, {:position, 2}, 99)

    assert {[0, 1, 2, 3], %{4 => 99}} = Computer.write([0, 1, 2, 3], %{}, 0, {:position, 4}, 99)

    assert {[0, 1, 2, 3], %{200 => 99}} =
             Computer.write([0, 1, 2, 3], %{}, 0, {:position, 200}, 99)
  end
end
