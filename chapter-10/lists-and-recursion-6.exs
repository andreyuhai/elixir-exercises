defmodule CustomEnum do
  # Exercise:ListsAndRecursion-6
  # Write a flatten(list) function that takes a list that may contain any
  # number of sublists, which themselves may contain sublists, to any depth.
  # It returns the elements of theses lists as a flat list
  def flatten([]), do: []
  def flatten([ head | tail ]) when is_list(head), do: flatten(head)
  def flatten([ head | tail ]), do: [head | flatten(tail)]
end

list = [1, 2, 3, [4, 5, 6, [7, 8, 9, [10, 11]]]]
IO.inspect CustomEnum.flatten(list)
# => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

