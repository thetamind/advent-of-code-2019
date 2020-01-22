defmodule Day10Test do
  use ExUnit.Case

  doctest Day10

  import Day10

  test "part 1 solution" do
    assert part1(File.read!("data/input.txt")) == {{17, 22}, 276}
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
