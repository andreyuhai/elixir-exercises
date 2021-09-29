defmodule Parallel do
  # Exercise:WorkingWithMultipleProcesses-6
  # In the pmap code, I assigned the value of self to the variable
  # me at the top of the method and then used me as the target of the message
  # returned by the spawned processes. Why use a separated variable?
  #
  # That's because since the function is going to be invoked within
  # the spawned process self() refers to the spawned process' PID so
  # we are passing the PID as a param instead.

  def pmap(collection, fun) do
    me = self()

    collection
    |> Enum.map(fn elem ->
      spawn_link(fn -> send me, { self(), fun.(elem) } end)
    end)
    |> Enum.map(fn pid ->
      receive do {^pid, result} -> result end
    end)
  end
end

Parallel.pmap(1..10, &(&1 * &1))
# => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

