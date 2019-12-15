defmodule Password do
  @moduledoc """
  Documentation for Password.
  """

  def part1(range) do
    range
    |> Enum.count(&valid?/1)
  end

  def part2(range) do
    range
    # |> Enum.take(100)
    |> Enum.count(&valid2?/1)
  end

  @doc """
  ## Examples

      iex> Password.valid?(111111)
      true

      iex> Password.valid?(223450)
      false

      iex> Password.valid?(123789)
      false
  """
  def valid?(password) do
    digits = Integer.digits(password)

    six_digits?(digits) and same_or_increase?(digits) and same_adjacent?(digits)
  end

  @doc """
  ## Examples

      iex> Password.valid2?(112233)
      true

      iex> Password.valid2?(123444)
      false

      iex> Password.valid2?(111122)
      true
  """
  def valid2?(password) do
    digits = Integer.digits(password)

    six_digits?(digits) and same_or_increase?(digits) and same_adjacent_exclusive?(digits)
  end

  def six_digits?(digits), do: Enum.count(digits) == 6

  def same_adjacent?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [left, right] -> left == right end)
  end

  def same_adjacent_exclusive?(digits) do
    candidates =
      digits
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn [left, right] -> left == right end)
      |> Enum.map(&List.first/1)
      |> Enum.uniq()

    trees =
      digits
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.filter(fn [left, mid, right] ->
        left == mid and mid == right
      end)
      |> Enum.map(&List.first/1)
      |> Enum.uniq()

    Enum.any?(candidates -- trees)
  end

  def same_or_increase?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [left, right] -> left <= right end)
  end
end
