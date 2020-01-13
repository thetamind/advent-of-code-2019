defmodule Day08Test do
  use ExUnit.Case

  test "part 1 example" do
    assert Day08.decode("123456789012", width: 3, height: 2) == [
             [[1, 2, 3], [4, 5, 6]],
             [[7, 8, 9], [0, 1, 2]]
           ]
  end
end
