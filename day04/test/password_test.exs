defmodule PasswordTest do
  use ExUnit.Case
  doctest Password

  test "part 1 solution" do
    assert Password.part1(123_257..647_015) == 2220
  end
end
