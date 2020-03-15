defmodule Computer.Day13Test do
  use ExUnit.Case, async: true

  alias Computer.Day13

  describe "part 1" do
    test "solution" do
      input = File.read!("data/day13.txt")
      assert Day13.part1(input) == 333
    end

    test "example" do
      tiles = Day13.parse_tiles([1, 2, 3, 6, 5, 4])

      assert Day13.count(tiles, :block) == 0
      assert Day13.count(tiles, :paddle) == 1
      assert Day13.count(tiles, :ball) == 1
    end
  end

  describe "parse tiles" do
    test "example 1" do
      assert Day13.parse_tiles([1, 2, 3, 6, 5, 4]) == [
               {:paddle, 1, 2},
               {:ball, 6, 5}
             ]
    end

    test "example 2" do
      assert Day13.parse_tiles([-1, 0, 12345]) == [
               {:score, 12345}
             ]
    end
  end
end
