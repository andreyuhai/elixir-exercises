defmodule MyList do
  # Exercise:ListsAndRecursion-4
  # Write a function MyList.span(from, to) that returns a list of the numbers from
  # from up to to.
  def span(to, to), do: [ to ]
  def span(from, to), do: [ from | span(from + 1, to) ]
end

IO.inspect MyList.span(5, 10)
# => [5, 6, 7, 8, 9, 10]
