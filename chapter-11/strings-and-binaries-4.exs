defmodule Parse do
  def number([ ?- | tail ]), do: _number_digits(tail, 0) * -1
  def number([ ?+ | tail ]), do: _number_digits(tail, 0)
  def number(str),         do: _number_digits(str, 0)

  defp _number_digits([], value), do: value
  defp _number_digits([ digit | tail ], value)
  when digit in '0123456789' do
    _number_digits(tail, value * 10 + digit - ?0)
  end

  defp _number_digits([ non_digit | _ ], _) do
    raise "Invalid digit '#{[non_digit]}'"
  end
end

defmodule StringsAndBinaries do
  # Exercise:StringsAndBinaries-4
  # Write a function that takes a single-quoted string of the form
  # number [+-*/] number and returns the result of the calculation.
  # The individual numbers do not have leading plus or minus sign.
  def calculate(char_list) do
    left = char_list |> Enum.take_while(fn c -> c in '0123456789' end)
    right = for c <- (char_list -- left), c in '0123456789', do: c
    operator = for c <- (char_list -- left) -- right, c in '+-/*', do: c

    left_num = Parse.number(left)
    right_num = Parse.number(right)

    case operator do
      '+' -> left_num + right_num
      '-' -> left_num - right_num
      '/' -> left_num / right_num
      '*' -> left_num * right_num
    end
  end
end

IO.puts StringsAndBinaries.calculate('123 + 27')
# => 150

