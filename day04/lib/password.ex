defmodule Password do
  @moduledoc """
  Documentation for Password.
  """

  @doc """
  ## Examples

      iex> Password.valid?(111111)
      true

      iex> Password.valid?(223450)
      false

      iex> Password.valid?(123789)
      false

  """

  def part1(range) do
    range
    |> Enum.count(&valid?/1)
  end

  def valid?(password) do
    digits = Integer.digits(password)

    six_digits?(digits) and same_adjacent?(digits) and same_or_increase?(digits)
  end

  def six_digits?(digits), do: Enum.count(digits) == 6

  def same_adjacent?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [left, right] -> left == right end)
  end

  def same_or_increase?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [left, right] -> left <= right end)
  end
end
