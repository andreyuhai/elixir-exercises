defmodule MyList do
  # Exercise:ListsAndRecursion-2
  # Write a max(list) that returns the element with the maximum value in the list.
  def max([]), do: 0
  def max([ head | tail ]), do: (if (head > (max_tail = max(tail))), do: head, else: max_tail)
end

IO.inspect MyList.max([9, 2, 3, 4, 11, 90, 20, 89, 99, 10, 111])
# => 111
