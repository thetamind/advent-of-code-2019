defmodule Day12Test do
  use ExUnit.Case

  import Day12

  describe "example 1" do
    test "moon positions" do
      input = ~S"""
      <x=-1, y=0, z=2>
      <x=2, y=-10, z=-7>
      <x=4, y=-8, z=8>
      <x=3, y=5, z=-1>
      """

      expected = [
        {-1, 0, 2},
        {2, -10, -7},
        {4, -8, 8},
        {3, 5, -1}
      ]

      assert load(input) == expected
    end
  end
end
