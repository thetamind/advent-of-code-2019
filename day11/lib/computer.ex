defmodule Computer do
  @moduledoc """
  Documentation for Computer.
  """

  defstruct ip: 0,
            base: 0,
            input: [],
            output: [],
            state: :virgin,
            label: nil,
            memory: [],
            uma: %{}

  def new() do
    %__MODULE__{}
  end

  def new(program, init_state) when is_map(init_state) do
    struct!(__MODULE__, Map.put(init_state, :memory, program))
  end

  def run(%Computer{} = state), do: do_run(state)
  def run(memory) when is_list(memory), do: run(memory, Computer.new())

  def run(memory, %Computer{} = state) when is_struct(state) do
    state = Map.put(state, :memory, memory)

    do_run(state)
  end

  def run(memory, init_state) when is_map(init_state) do
    state = struct!(__MODULE__, Map.put(init_state, :memory, memory))

    do_run(state)
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
  def decode_mode(2), do: :relative

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
        9 -> 1
        99 -> 0
        _ -> 3
      end

    params = Enum.slice(slice, 1, num_params)

    {op, Enum.zip(modes, params)}
  end

  def read(%{memory: memory, uma: uma, base: base}, {mode, param}),
    do: read(memory, uma, base, {mode, param})

  def read(memory, uma, base, {mode, param}) do
    case mode do
      :position -> Enum.at(memory, param) || Map.get(uma, param, 0)
      :immediate -> param
      :relative -> Enum.at(memory, base + param) || Map.get(uma, base + param, 0)
    end
  end

  def write(memory, uma, base, {mode, param}, value) do
    address =
      case mode do
        :position -> param
        :immediate -> raise("Write with invalid mode: #{inspect({mode, param})}")
        :relative -> base + param
      end

    if address < Enum.count(memory) do
      {List.replace_at(memory, address, value), uma}
    else
      {memory, Map.put(uma, address, value)}
    end
  end

  require Logger

  def do_run(%{memory: memory, ip: ip} = state) do
    {op, params} = decode(memory, ip)
    # Logger.debug("#{inspect(ip)}  #{inspect(op)}  #{inspect(params)}")
    do_run(op, params, state)
  end

  def do_run(
        1,
        [inpos1, inpos2, outpos],
        %{memory: memory, uma: uma, base: base, ip: ip} = state
      ) do
    in1 = read(memory, uma, base, inpos1)
    in2 = read(memory, uma, base, inpos2)

    value = in1 + in2

    {memory, uma} = write(memory, uma, base, outpos, value)

    do_run(%{state | memory: memory, uma: uma, ip: ip + 4})
  end

  def do_run(2, [inpos1, inpos2, outpos], %{memory: memory, uma: uma, base: base, ip: ip} = state) do
    in1 = read(memory, uma, base, inpos1)
    in2 = read(memory, uma, base, inpos2)
    value = in1 * in2

    {memory, uma} = write(memory, uma, base, outpos, value)

    do_run(%{state | memory: memory, uma: uma, ip: ip + 4})
  end

  def do_run(3, [address], %{memory: memory, uma: uma, base: base, ip: ip, input: input} = state) do
    if input == [] do
      %{state | state: :wait_input}
    else
      {value, input} = List.pop_at(input, 0)

      {memory, uma} = write(memory, uma, base, address, value)

      do_run(%{state | memory: memory, uma: uma, ip: ip + 2, input: input})
    end
  end

  def do_run(
        4,
        [address],
        %{memory: memory, uma: uma, base: base, ip: ip, output: output} = state
      ) do
    value = read(memory, uma, base, address)

    output = List.insert_at(output, -1, value)

    do_run(%{state | memory: memory, ip: ip + 2, output: output})
  end

  def do_run(5, [address, new_ip], %{memory: memory, uma: uma, base: base, ip: ip} = state) do
    ip =
      case read(memory, uma, base, address) do
        0 -> ip + 3
        _ -> read(memory, uma, base, new_ip)
      end

    do_run(%{state | memory: memory, ip: ip})
  end

  def do_run(6, [address, new_ip], %{memory: memory, uma: uma, base: base, ip: ip} = state) do
    ip =
      case read(memory, uma, base, address) do
        0 -> read(memory, uma, base, new_ip)
        _ -> ip + 3
      end

    do_run(%{state | memory: memory, ip: ip})
  end

  def do_run(7, [first, second, outpos], %{memory: memory, uma: uma, base: base, ip: ip} = state) do
    value = if read(memory, uma, base, first) < read(memory, uma, base, second), do: 1, else: 0

    {memory, uma} = write(memory, uma, base, outpos, value)

    do_run(%{state | memory: memory, uma: uma, ip: ip + 4})
  end

  def do_run(8, [first, second, outpos], %{memory: memory, uma: uma, base: base, ip: ip} = state) do
    value = if read(memory, uma, base, first) == read(memory, uma, base, second), do: 1, else: 0

    {memory, uma} = write(memory, uma, base, outpos, value)

    do_run(%{state | memory: memory, uma: uma, ip: ip + 4})
  end

  def do_run(9, [param], %{base: base, ip: ip} = state) do
    value = read(state, param)

    do_run(%{state | base: base + value, ip: ip + 2})
  end

  def do_run(99, [], state) do
    Map.put(state, :state, :halt)
  end

  def add_input(state, value) when not is_list(value) do
    Map.update!(state, :input, fn input -> List.insert_at(input, -1, value) end)
  end

  def output(%{output: output}), do: output

  def halted?(%{state: state}), do: state == :halt
end
