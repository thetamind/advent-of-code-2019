defmodule Computer do
  @moduledoc """
  Documentation for Computer.
  """

  @doc """
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
    |> restore(12, 2)
    |> run()
    |> Enum.at(0)
  end

  def part2(input) do
    memory =
      input
      |> load()

    for noun <- 0..99, verb <- 0..99 do
      memory
      |> restore(noun, verb)
      |> run()
      |> Enum.take(3)
    end
    # IDEA: Binary search? Output appears linear
    |> Enum.find_value(fn [output, noun, verb] ->
      if output == 19_690_720, do: 100 * noun + verb
    end)
  end

  def run(memory) do
    do_run(0, memory)
  end

  def load(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def restore(memory, noun, verb) do
    memory
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def do_run(ip, memory) do
    read = memory |> Enum.drop(ip) |> Enum.take(4)
    do_run(read, ip, memory)
  end

  def do_run([1, inpos1, inpos2, outpos], ip, memory) do
    in1 = Enum.at(memory, inpos1)
    in2 = Enum.at(memory, inpos2)
    value = in1 + in2

    memory = List.replace_at(memory, outpos, value)

    do_run(ip + 4, memory)
  end

  def do_run([2, inpos1, inpos2, outpos], ip, memory) do
    in1 = Enum.at(memory, inpos1)
    in2 = Enum.at(memory, inpos2)
    value = in1 * in2

    memory = List.replace_at(memory, outpos, value)

    do_run(ip + 4, memory)
  end

  def do_run([99 | _], _pc, memory) do
    memory
  end
end
