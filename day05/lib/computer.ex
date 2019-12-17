defmodule Computer do
  @moduledoc """
  Documentation for Computer.
  """

  def run(memory, state \\ %{}) do
    state =
      state
      |> Map.put(:ip, 0)
      |> Map.put(:output, [])

    do_run(memory, state)
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

  def decode(memory, ip) do
    num_params =
      case Enum.at(memory, ip) do
        3 -> 1
        4 -> 1
        99 -> 0
        _ -> 3
      end

    memory |> Enum.drop(ip) |> Enum.take(1 + num_params)
  end

  def do_run(memory, %{ip: ip} = state) do
    read = decode(memory, ip)
    do_run(read, memory, state)
  end

  def do_run([1, inpos1, inpos2, outpos], memory, %{ip: ip} = state) do
    in1 = Enum.at(memory, inpos1)
    in2 = Enum.at(memory, inpos2)
    value = in1 + in2

    memory = List.replace_at(memory, outpos, value)

    do_run(memory, %{state | ip: ip + 4})
  end

  def do_run([2, inpos1, inpos2, outpos], memory, %{ip: ip} = state) do
    in1 = Enum.at(memory, inpos1)
    in2 = Enum.at(memory, inpos2)
    value = in1 * in2

    memory = List.replace_at(memory, outpos, value)

    do_run(memory, %{state | ip: ip + 4})
  end

  def do_run([3, address], memory, %{ip: ip, input: input} = state) do
    {value, input} = List.pop_at(input, 0)

    memory = List.replace_at(memory, address, value)

    do_run(memory, %{state | ip: ip + 2, input: input})
  end

  def do_run([4, address], memory, %{ip: ip, output: output} = state) do
    value = Enum.at(memory, address)

    output = List.insert_at(output, 0, value)

    do_run(memory, %{state | ip: ip + 2, output: output})
  end

  def do_run([99 | _], memory, state) do
    Map.put(state, :memory, memory)
  end
end
