defmodule WorkingWithMultipleProcesses do
  import :timer, only: [sleep: 1]
  # Exercise:WorkingWithMultipleProcesses-4
  # Do the same as Exercise 3 but have the child raise an exception.
  # What difference do you see in the tracing?

  def listen do
    raise "Something went wrong"
  end

  def run do
    spawn_link(WorkingWithMultipleProcesses, :listen, [])

    sleep(5000)
    main_listen()
  end

  def main_listen do
    receive do
      {:ok, msg} ->
        IO.puts "MESSAGE RECEIVED: #{msg}"
        main_listen()
    end
  end
end

WorkingWithMultipleProcesses.run()
# => ** (EXIT from #PID<0.93.0>) an exception was raised:
#    ** (RuntimeError) Something went wrong
#        working-with-multiple-processes-4.exs:8: WorkingWithMultipleProcesses.listen/0
# Exits after the child raises an exception

