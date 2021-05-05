defmodule StringsAndBinaries do
  # Exercise:StringsAndBinaries-6
  # Write a function to capitalize the sentences in a string. Each sentence is
  # terminated by a period and a space. Right now, the case of the characters
  # in the string is random.
  #
  # 1ST METHOD
  def capitalize_sentences(str), do: String.split(str, ". ") |> Enum.map(&String.capitalize/1) |> Enum.reduce(fn x, acc -> acc <> ". " <> x end)

  # 2ND METHOD
  def capitalize_sentences(str), do: _capitalize_sentences(str, "", 2)

  def _capitalize_sentences(<<>>, acc, _),                                do: acc
  def _capitalize_sentences(<< "." , tail :: binary >>, acc, 0),          do: _capitalize_sentences(tail, acc <> ".", 1)
  def _capitalize_sentences(<< head :: utf8, tail :: binary >>, acc, 0),  do: _capitalize_sentences(tail, acc <> String.downcase(to_string([head])), 0)
  def _capitalize_sentences(<< " "  :: utf8, tail :: binary >>, acc, 1),  do: _capitalize_sentences(tail, acc <> " ", 2)
  def _capitalize_sentences(<< head :: utf8, tail :: binary >>, acc, 1),  do: _capitalize_sentences(tail, acc <> String.downcase(to_string([head])), 0)
  def _capitalize_sentences(<< head :: utf8, tail :: binary >>, acc, 2),  do: _capitalize_sentences(tail, acc <> String.upcase(to_string([head])), 0)
end

IO.inspect StringsAndBinaries.capitalize_sentences("oh. a DOG. woof.")
# => "Oh. A dog. Woof."

