defmodule StringsAndBinaries do
  # Exercise:StringsAndBinaries-5
  # Write a function that takes a list of double-quoted strings
  # and prints each on a separate line, centered in a column that has the width of the longest
  # string. Make sure it works with UTF characters.
  def center(list) do
    max_len = list |> Enum.map(&String.length/1) |> Enum.max

    for str <- list do
      if String.length(str) < max_len do
        IO.puts(String.duplicate(" ", floor((max_len - String.length(str))/2)) <> str)
      else
        IO.puts str
      end
    end
  end
end

StringsAndBinaries.center(["cat", "zebra", "apple", "umbrella", "elephant", "hełło"])
# =>
#  cat
# zebra
# apple
#umbrella
#elephant
# hełło

