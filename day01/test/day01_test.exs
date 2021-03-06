defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "part 1 examples" do
    assert Day01.fuel_required(12) == 2
    assert Day01.fuel_required(14) == 2
    assert Day01.fuel_required(1969) == 654
    assert Day01.fuel_required(100_756) == 33_583
  end

  test "part 1 result" do
    assert Day01.part1() == 3_270_338
  end

  test "part 2 examples" do
    assert Day01.total_fuel_required(14) == 2
    assert Day01.total_fuel_required(1969) == 966
    assert Day01.total_fuel_required(100_756) == 50_346
  end

  test "part 2 result" do
    assert Day01.part2() == 4_902_650
  end
end
