defmodule Day12.Utils do
  @spec gcd(integer(), integer()) :: integer()
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  @spec lcm(integer(), integer()) :: integer()
  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))

  @spec comb(non_neg_integer(), Enum.t()) :: [Enum.t()]
  def comb(0, _), do: [[]]
  def comb(_, []), do: []

  def comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end

  # this crazy clever algorithm hails from
  # http://stackoverflow.com/questions/5389254/transposing-a-2-dimensional-matrix-in-erlang
  # and is apparently from the Haskell stdlib. I implicitly trust Haskellers.
  def transpose([[x | xs] | xss]) do
    [[x | for([h | _] <- xss, do: h)] | transpose([xs | for([_ | t] <- xss, do: t)])]
  end

  def transpose([[] | xss]), do: transpose(xss)

  def transpose([]), do: []
end
