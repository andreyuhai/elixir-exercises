defmodule StringsAndBinaries do
  # Exercise:StringsAndBinaries-2
  # Write an anagram?(word1, word2) that returns true if
  # its parameters are anagrams
  def anagram?(word1, word2), do: word1 -- word2 == []
end

IO.puts StringsAndBinaries.anagram?('alert', 'alter')
# => true

