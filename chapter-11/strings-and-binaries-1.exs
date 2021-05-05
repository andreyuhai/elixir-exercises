defmodule StringsAndBinaries do
  # Exercise:StringsAndBinaries-1
  # Write a function that returns true if a single-quoted string contains only
  # printable ASCII characters (space through tilde)
  def printable?(char_list), do: char_list |> Enum.all?(fn char -> char in ?\s..?~ end)
end

IO.puts StringsAndBinaries.printable?('foo')
# => true

IO.puts StringsAndBinaries.printable?('hełło')
# => false
