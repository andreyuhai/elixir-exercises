defmodule WorkingWithMultipleProcesses do
  import :timer, only: [sleep: 1]
  # Exercise:WorkingWithMultipleProcesses-5
  # Repeat the exercises 3 and 4, changing spawn_link to spawn_monitor.

  def listen do
    raise "Something went wrong"
  end

  def run do
    spawn_monitor(WorkingWithMultipleProcesses, :listen, [])

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
# =>
# 16:51:14.171 [error] Process #PID<0.98.0> raised an exception
# ** (RuntimeError) Something went wrong
#     working-with-multiple-processes-5-2.exs:7: WorkingWithMultipleProcesses.listen/0
# .
# .
# Keeps listening after logging the error

