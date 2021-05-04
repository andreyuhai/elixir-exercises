defmodule MyList do
  # Exercise:ListsAndRecursion-1
  # Write a mapsum function that takes a list and a function. It applies the
  # function to each element of the list and then sums the result.
  def mapsum([], _func), do: 0
  def mapsum([ head | tail ], func), do: func.(head) + mapsum(tail, func)
end

IO.puts MyList.mapsum([1, 2, 3], &(&1 * &1))
# => 14

