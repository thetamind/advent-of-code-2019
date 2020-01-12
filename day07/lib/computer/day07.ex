defmodule Computer.Day07 do
  @moduledoc """
  Documentation for `Computer.Day07`.

  ## Part 1 Examples

      iex> Computer.Day07.part1("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", [4,3,2,1,0])
      43210

      iex> Computer.Day07.part1("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", [0,1,2,3,4])
      54321

      iex> Computer.Day07.part1("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", [1,0,4,3,2])
      65210

  ## Part 2 Examples

      iex> Computer.Day07.part2("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5", [9,8,7,6,5])
      139629729

      iex> Computer.Day07.part2("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10", [9,7,8,5,6])
      18216

  """

  import Computer

  def part1(input, phases) do
    program = load(input)

    phases
    |> permutations()
    |> Enum.map(fn phases -> thrust(program, phases, [0]) end)
    |> Enum.max()
  end

  def thrust(program, phases, input) do
    Enum.reduce(phases, input, fn phase, input ->
      input = input |> List.wrap() |> List.insert_at(0, phase)
      result = Computer.run(program, %{input: input})
      result.output
    end)
    |> List.first()
  end

  def part2(input, phases) do
    program = load(input)

    amps = make_amps(program, phases)

    {amps, signal} = feedback(amps, 0)
    feedback(amps, signal)
  end

  # setup state
  # phases 5 6 7 8 9
  # Amp A B C D E
  # reduce A -> E
  # Take E output and loop into A
  # When halt????, E output is answer

  @spec make_amps([integer], [integer]) :: [Computer.t()]
  def make_amps(program, phases) do
    label_gen = for c <- ?A..?Z, do: <<c>>

    phases
    |> Enum.zip(label_gen)
    |> Enum.map(fn {phase, label} ->
      Computer.new()
      |> Map.put(:memory, program)
      |> Map.put(:label, label)
      |> Computer.add_input(phase)
    end)
  end

  @spec feedback([Computer.t()], integer) :: {[Computer.t()], integer}
  def feedback(amps, signal) do
    # TODO: Use Enum.flat_map_reduce/3

    Enum.flat_map_reduce(amps, signal, fn amp, acc ->
      amp =
        amp
        |> Computer.add_input(acc)
        |> Computer.run()

      # IO.inspect(amp, label: "output #{amp.label}", charlists: :as_lists, width: 140)
      output = Computer.output(amp) |> List.first()

      # if amp.label == "E", do: {:halt, output}, else: {[amp], output}
      {[amp], output}
    end)

    # |> Computer.output()
    # |> List.first()

    # Enum.reduce(amps, signal, fn amp, state ->
    #   {value, output} = List.pop_at(state.output, 0)

    #   state =
    #     case value do
    #       nil ->
    #         Computer.add_input(state, phase)

    #       value ->
    #         Computer.add_input(state, value)
    #     end

    #   state = %{state | output: output}

    #   Computer.run(program, state)
    # end)
    # |> Computer.output()
    # |> List.first()

    # List.first(state.output)
  end

  def permutations([]), do: [[]]

  def permutations(list) do
    for x <- list, y <- permutations(list -- [x]), do: [x | y]
  end
end
