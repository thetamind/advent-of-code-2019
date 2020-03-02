defmodule Computer.Day09Test do
  use ExUnit.Case, async: true

  doctest Computer.Day09

  test "part 1 solution" do
    input = File.read!("data/day09.txt")
    assert Computer.Day09.part1(input) == [2_351_176_124]
  end

  @tag timeout: 20_000
  @tag :slow
  test "part 2 solution" do
    input = File.read!("data/day09.txt")
    assert Computer.Day09.part2(input) == [73110]
  end

  test "write with upper memory area support" do
    assert {[0, 1, 99, 3], _uma} = Computer.write([0, 1, 2, 3], %{}, 0, {:position, 2}, 99)

    assert {[0, 1, 2, 3], %{4 => 99}} = Computer.write([0, 1, 2, 3], %{}, 0, {:position, 4}, 99)

    assert {[0, 1, 2, 3], %{200 => 99}} =
             Computer.write([0, 1, 2, 3], %{}, 0, {:position, 200}, 99)
  end

  # https://www.reddit.com/r/adventofcode/comments/e8aw9j/2019_day_9_part_1_how_to_fix_203_error/fac3294/
  describe "fix 203 error" do
    test "op 4" do
      assert Computer.run([109, -1, 4, 1, 99]) |> Computer.output() == [-1]
    end

    test "op 104" do
      assert Computer.run([109, -1, 104, 1, 99]) |> Computer.output() == [1]
    end

    test "op 204" do
      assert Computer.run([109, -1, 204, 1, 99]) |> Computer.output() == [109]
    end

    test "op 9" do
      assert Computer.run([109, 1, 9, 2, 204, -6, 99]) |> Computer.output() == [204]
    end

    test "op 109" do
      assert Computer.run([109, 1, 109, 9, 204, -6, 99]) |> Computer.output() == [204]
    end

    test "op 209" do
      assert Computer.run([109, 1, 209, -1, 204, -106, 99]) |> Computer.output() == [204]
    end

    test "op 3" do
      assert Computer.run([109, 1, 3, 3, 204, 2, 99], %{input: [55]}) |> Computer.output() == [55]
    end

    test "op 203" do
      assert Computer.run([109, 1, 203, 2, 204, 2, 99], %{input: [55]}) |> Computer.output() == [
               55
             ]
    end
  end
end
