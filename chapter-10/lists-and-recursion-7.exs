defmodule MyList do
  # Exercise:ListsAndRecursion-7
  # Return a list of the prime numbers from 2 to n
  # using the span function you've written in Exercise 4
  def span(to, to), do: [ to ]
  def span(from, to), do: [ from | span(from + 1, to) ]

  def span_prime(n), do: for x <- span(2, n), prime?(x), do: x

  def prime?(0), do: false
  def prime?(2), do: true
  def prime?(n), do: 2..round(:math.sqrt(n)) |> Enum.filter(&(rem(n, &1) == 0)) |> length() == 0
end

IO.inspect MyList.span_prime(10)
# => [2, 3, 5, 7]
