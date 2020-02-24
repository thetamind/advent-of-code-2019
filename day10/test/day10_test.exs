defmodule Day10Test do
  use ExUnit.Case

  doctest Day10

  import Day10

  test "part 1 solution" do
    assert part1(File.read!("data/input.txt")) == {{17, 22}, 276}
  end

  test "part 2 solution" do
    assert part2(File.read!("data/input.txt"), {17, 22}) == {13, 21}
  end

  @small_example ~S"""
  .#..#
  .....
  #####
  ....#
  ...##
  """

  @example1 ~S"""
  ......#.#.
  #..#.#....
  ..#######.
  .#.#.###..
  .#..#.....
  ..#....#.#
  #..#....#.
  .##.#..###
  ##...#..#.
  .#....####
  """

  @example2 ~S"""
  #.#...#.#.
  .###....#.
  .#....#...
  ##.#.#.#.#
  ....#.#.#.
  .##..###.#
  ..#...##..
  ..##....##
  ......#...
  .####.###.
  """

  @example3 ~S"""
  .#..#..###
  ####.###.#
  ....###.#.
  ..###.##.#
  ##.##.#.#.
  ....###..#
  ..#.#..#.#
  #..#.#.###
  .##...##.#
  .....#.#..
  """

  @example4 File.read!("data/example4.txt")

  test "parse" do
    asteroids = Day10.parse(@small_example)

    assert Enum.member?(asteroids, {1, 0})
    assert Enum.member?(asteroids, {4, 0})
    assert Enum.member?(asteroids, {2, 2})
    assert Enum.member?(asteroids, {4, 4})

    refute Enum.member?(asteroids, {0, 0})
    refute Enum.member?(asteroids, {9, 2})
    refute Enum.member?(asteroids, {5, 5})
  end

  test "load" do
    map = Day10.load(@small_example)

    assert Day10.Map.member?(map, 3, 4)
    refute Day10.Map.member?(map, 0, 0)
  end

  test "visible_count" do
    map = Day10.load(@small_example)

    assert Day10.Map.visible_count(map, {3, 4}) == 8
    assert Day10.Map.visible_count(map, {1, 0}) == 7
    assert Day10.Map.visible_count(map, {4, 2}) == 5
  end

  test "visible?" do
    map = Day10.load(@small_example)

    assert Day10.Map.visible?(map, {3, 4}, {2, 2})
    refute Day10.Map.visible?(map, {3, 4}, {1, 0})
  end

  describe "best_location/1" do
    test "small example" do
      map = Day10.load(@small_example)

      assert Day10.best_location(map) == {{3, 4}, 8}
    end

    test "example 1" do
      assert load(@example1) |> best_location() == {{5, 8}, 33}
    end

    test "example 2" do
      assert load(@example2) |> best_location() == {{1, 2}, 35}
    end

    test "example 3" do
      assert load(@example3) |> best_location() == {{6, 3}, 41}
    end

    test "example 4" do
      assert load(@example4) |> best_location() == {{11, 13}, 210}
    end
  end

  describe "same slope in different quadrant" do
    setup :quad_map

    test "visible?", %{quad_map: map} do
      assert Day10.Map.visible?(map, {2, 2}, {1, 1})
      assert Day10.Map.visible?(map, {2, 2}, {3, 3})
      refute Day10.Map.visible?(map, {2, 2}, {0, 0})
      refute Day10.Map.visible?(map, {2, 2}, {4, 4})
    end

    test "visible_count", %{quad_map: map} do
      assert Day10.Map.visible_count(map, {2, 2}) == 4
    end
  end

  describe "giant rotating laser" do
    setup [:laser_map]

    test "example first rotation", %{laser_map: map} do
      destroyed = Day10.giant_rotating_laser(map, {8, 3})

      assert Enum.take(destroyed, 9) == [
               {8, 1},
               {9, 0},
               {9, 1},
               {10, 0},
               {9, 2},
               {11, 1},
               {12, 1},
               {11, 2},
               {15, 1}
             ]
    end

    test "example second rotation", %{laser_map: map} do
      destroyed = Day10.giant_rotating_laser(map, {8, 3})

      assert Enum.take(destroyed, 18) |> Enum.drop(9) == [
               {12, 2},
               {13, 2},
               {14, 2},
               {15, 2},
               {12, 3},
               {16, 4},
               {15, 4},
               {10, 4},
               {4, 4}
             ]
    end

    test "large example" do
      map = load(@example4)
      destroyed = Day10.giant_rotating_laser(map, {11, 13})

      assert Enum.take(destroyed, 3) == [{11, 12}, {12, 1}, {12, 2}]
      assert Enum.at(destroyed, 10 - 1) == {12, 8}
      assert Enum.at(destroyed, 20 - 1) == {16, 0}
      assert Enum.at(destroyed, 50 - 1) == {16, 9}
      assert Enum.at(destroyed, 100 - 1) == {10, 16}
      assert Enum.at(destroyed, 199 - 1) == {9, 6}
      assert Enum.at(destroyed, 200 - 1) == {8, 2}
      assert Enum.at(destroyed, 201 - 1) == {10, 9}
      assert Enum.at(destroyed, 299 - 1) == {11, 1}
    end
  end

  test "transpose rotate values" do
    orig = [
      [1, 2, 3],
      [11, 12, 13, 14],
      [21, 22]
    ]

    expected = [
      [1, 11, 21],
      [2, 12, 22],
      [3, 13],
      [14]
    ]

    assert Day10.Map.transpose(orig) == expected
  end

  test "transpose_map pair with keys while rotating values" do
    orig = %{
      a: [1, 2, 3],
      b: [11, 12, 13, 14],
      c: [21, 22]
    }

    expected = [
      [a: 1, b: 11, c: 21],
      [a: 2, b: 12, c: 22],
      [a: 3, b: 13],
      [b: 14]
    ]

    assert Day10.Map.transpose_map(orig) == expected
  end

  defp laser_map(_context) do
    map =
      ~S"""
      .#....#####...#..
      ##...##.#####..##
      ##...#...#.#####.
      ..#.....X...###..
      ..#.#.....#....##
      """
      |> load()

    [laser_map: map]
  end

  defp quad_map(_context) do
    map =
      ~S"""
      #...#
      .#.#.
      ..#..
      .#.#.
      #...#
      """
      |> load()

    [quad_map: map]
  end
end
