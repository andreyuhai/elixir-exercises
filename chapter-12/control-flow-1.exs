defmodule FizzBuzz do
  # Exercise:ControlFlow-1
  # Rewrite the FizzBuzz example using case.
  def upto(num), do: 1..num |> Enum.map(&fizzbuzz/1)

  def fizzbuzz(num) do
    case {num, rem(num, 3), rem(num, 5)} do
      {_num, 0, 0} -> "FizzBuzz"
      {_num, 0, _} -> "Fizz"
      {_num, _, 0} -> "Buzz"
      {num, _, _} -> num
    end
  end
end

IO.inspect FizzBuzz.upto(15)
# => [1, 2, "Fizz", 4, "Buzz", "Fizz", 7, 8, "Fizz", "Buzz", 11, "Fizz", 13, 14, "FizzBuzz"]
