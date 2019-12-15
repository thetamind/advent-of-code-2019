defmodule Computer do
  @moduledoc """
  Documentation for Computer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Computer.run([1,0,0,0,99])
      [2,0,0,0,99]

      iex> Computer.run([2,3,0,3,99])
      [2,3,0,6,99]

      iex> Computer.run([2,4,4,5,99,0])
      [2,4,4,5,99,9801]

      iex> Computer.run([1,1,1,4,99,5,6,0,99])
      [30,1,1,4,2,5,6,0,99]

      iex> Computer.run([1,9,10,3,2,3,11,0,99,30,40,50])
      [3500,9,10,70,2,3,11,0,99,30,40,50]

  """

  def part1(input) do
    input
    |> load()
    |> restore()
    |> run
    |> Enum.at(0)
  end

  def run(code) do
    do_run(0, code)
  end

  def load(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def restore(code) do
    code
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
  end

  def do_run(pc, code) do
    read = code |> Enum.drop(pc) |> Enum.take(4)
    do_run(read, pc, code)
  end

  def do_run([1, inpos1, inpos2, outpos], pc, code) do
    in1 = Enum.at(code, inpos1)
    in2 = Enum.at(code, inpos2)
    value = in1 + in2

    code = List.replace_at(code, outpos, value)

    do_run(pc + 4, code)
  end

  def do_run([2, inpos1, inpos2, outpos], pc, code) do
    in1 = Enum.at(code, inpos1)
    in2 = Enum.at(code, inpos2)
    value = in1 * in2

    code = List.replace_at(code, outpos, value)

    do_run(pc + 4, code)
  end

  def do_run([99 | _], _pc, code) do
    code
  end
end
