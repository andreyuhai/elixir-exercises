defmodule MyList do
  # Exercise:ListsAndRecursion-3
  # Write a caesar(list, n) function that adds n to each list element, wrapping if the addition
  # results in a character greater than z.
  def caesar([], _n), do: []
  def caesar([ head | tail ], n), do: [ rem(head + n, ?z) | caesar(tail, n) ]
end

IO.puts MyList.caesar('ryvkve', 13)
# => 	x	r (This was supposed to be Elixir I think, not sure why I get that whitespace)
