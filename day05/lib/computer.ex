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

  def decode_op(number) do
    digits = Integer.digits(number)
    op = Integer.undigits(Enum.take(digits, -2))
    mode1 = Enum.at(digits, -3, 0)
    mode2 = Enum.at(digits, -4, 0)
    mode3 = Enum.at(digits, -5, 0)

    {op, [decode_mode(mode1), decode_mode(mode2), decode_mode(mode3)]}
  end

  def decode_mode(0), do: :position
  def decode_mode(1), do: :immediate

  def decode(memory, ip) do
    slice = Enum.slice(memory, ip, 4)
    {op, modes} = decode_op(List.first(slice))

    num_params =
      case op do
        3 -> 1
        4 -> 1
        5 -> 2
        6 -> 2
        7 -> 3
        8 -> 3
        99 -> 0
        _ -> 3
      end

    params = Enum.slice(slice, 1, num_params)

    {op, Enum.zip(modes, params)}
  end

  def read(memory, {mode, param}) do
    case mode do
      :position -> Enum.at(memory, param)
      :immediate -> param
    end
  end

  def write(memory, {mode, param}, value) do
    if mode == :immediate, do: raise("Write with invalid mode: #{{mode, param}}")
    List.replace_at(memory, param, value)
  end

  def do_run(memory, %{ip: ip} = state) do
    {op, params} = decode(memory, ip)
    do_run(op, params, memory, state)
  end

  def do_run(1, [inpos1, inpos2, outpos], memory, %{ip: ip} = state) do
    in1 = read(memory, inpos1)
    in2 = read(memory, inpos2)
    value = in1 + in2

    memory = write(memory, outpos, value)

    do_run(memory, %{state | ip: ip + 4})
  end

  def do_run(2, [inpos1, inpos2, outpos], memory, %{ip: ip} = state) do
    in1 = read(memory, inpos1)
    in2 = read(memory, inpos2)
    value = in1 * in2

    memory = write(memory, outpos, value)

    do_run(memory, %{state | ip: ip + 4})
  end

  def do_run(3, [address], memory, %{ip: ip, input: input} = state) do
    {value, input} = List.pop_at(input, 0)

    memory = write(memory, address, value)

    do_run(memory, %{state | ip: ip + 2, input: input})
  end

  def do_run(4, [address], memory, %{ip: ip, output: output} = state) do
    value = read(memory, address)

    output = List.insert_at(output, 0, value)

    do_run(memory, %{state | ip: ip + 2, output: output})
  end

  def do_run(5, [address, new_ip], memory, %{ip: ip} = state) do
    ip =
      case read(memory, address) do
        0 -> ip + 3
        _ -> read(memory, new_ip)
      end

    do_run(memory, %{state | ip: ip})
  end

  def do_run(6, [address, new_ip], memory, %{ip: ip} = state) do
    ip =
      case read(memory, address) do
        0 -> read(memory, new_ip)
        _ -> ip + 3
      end

    do_run(memory, %{state | ip: ip})
  end

  def do_run(7, [first, second, outpos], memory, %{ip: ip} = state) do
    value = if read(memory, first) < read(memory, second), do: 1, else: 0

    memory = write(memory, outpos, value)

    do_run(memory, %{state | ip: ip + 4})
  end

  def do_run(8, [first, second, outpos], memory, %{ip: ip} = state) do
    value = if read(memory, first) == read(memory, second), do: 1, else: 0

    memory = write(memory, outpos, value)

    do_run(memory, %{state | ip: ip + 4})
  end

  def do_run(99, [], memory, state) do
    Map.put(state, :memory, memory)
  end
end
