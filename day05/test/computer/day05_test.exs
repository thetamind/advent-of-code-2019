defmodule Computer.Day05Test do
  use ExUnit.Case, async: true
  doctest Computer.Day05

  test "part 1 solution" do
    input = File.read!("data/day05.txt")
    assert Computer.Day05.part1(input) == 6_745_903
  end

  test "part 2 solution" do
    input = File.read!("data/day05.txt")
    assert Computer.Day05.part2(input) == 9_168_267
  end

  test "part 2 examples" do
    input = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
    assert %{output: [1]} = Computer.run(input, %{input: [8]})
    assert %{output: [0]} = Computer.run(input, %{input: [15]})

    input = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
    assert %{output: [1]} = Computer.run(input, %{input: [5]})
    assert %{output: [0]} = Computer.run(input, %{input: [12]})

    input = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
    assert %{output: [1]} = Computer.run(input, %{input: [8]})
    assert %{output: [0]} = Computer.run(input, %{input: [15]})

    input = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
    assert %{output: [1]} = Computer.run(input, %{input: [5]})
    assert %{output: [0]} = Computer.run(input, %{input: [12]})

    input = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
    assert %{output: [1]} = Computer.run(input, %{input: [5]})
    assert %{output: [0]} = Computer.run(input, %{input: [0]})

    input = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]
    assert %{output: [1]} = Computer.run(input, %{input: [5]})
    assert %{output: [0]} = Computer.run(input, %{input: [0]})
  end

  test "part 2 large example" do
    input =
      Computer.load(
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      )

    assert %{output: [999]} = Computer.run(input, %{input: [7]})
    assert %{output: [1000]} = Computer.run(input, %{input: [8]})
    assert %{output: [1001]} = Computer.run(input, %{input: [9]})
  end
end
