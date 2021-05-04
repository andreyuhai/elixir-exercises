# Exercise:ListsAndRecursion-5
# Implement the following Enum functions using no library functions
# or list comprehensions: all?, each, filter, split and take. You may need to
# use an if statement to implement filter.
defmodule CustomEnum do
  def all?([], _func), do: true
  def all?([ head | tail ], func), do: func.(head) and all?(tail, func)

  def each([], _func), do: :ok
  def each([ head | tail ], func), do: func.(head) && each(tail, func)

  def filter([], _func), do: []
  def filter([ head | tail ], func), do: (if (func.(head)), do: [head | filter(tail, func)], else: filter(tail, func) )

  def split([], _num), do: []
  def split(list, num), do: split_helper(list, [], num)
  defp split_helper(rest, acc, num) when num == 0 or rest == [], do: {Enum.reverse(acc), rest}
  defp split_helper([ head | tail ], acc, num), do: split_helper(tail, [head | acc], num - 1)

  def take([], _num), do: []
  def take(_, num) when num == 0, do: []
  def take([ head | tail ], num) when num > 0, do: [head | take(tail, num - 1)]
  def take(list, num) when num < 0, do: take_helper(list, num, 0, length(list))
  defp take_helper(list, num, counter, length) when counter - length >= num, do: take(list, abs(num))
  defp take_helper([ _head | tail ], num,  counter, length), do: take_helper(tail, num, counter + 1, length)
end

list = [1, 2, 3, 4]

IO.inspect CustomEnum.all?(list, &(&1 > 0))
# => true

IO.inspect CustomEnum.each(list, &(IO.puts &1))
# 1
# 2
# 3
# 4
# => :ok

IO.inspect CustomEnum.filter(list, &(&1 > 2))
# => [3, 4]

IO.inspect CustomEnum.split(list, 3)
# => {[1, 2, 3], [4]}

IO.inspect CustomEnum.take(list, 2)
# => [1, 2]

IO.inspect CustomEnum.take(list, -2)
# => [3, 4]

IO.inspect CustomEnum.take(list, 6)
# => [1, 2, 3, 4]

IO.inspect CustomEnum.take(list, -6)
# => [1, 2, 3, 4]
