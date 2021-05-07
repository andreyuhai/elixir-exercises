defmodule WorkingWithMultipleProcesses do
  import :timer, only: [sleep: 1]
  # Exercise:WorkingWithMultipleProcesses-5
  # Repeat the exercises 3 and 4, changing spawn_link to spawn_monitor.

  def listen(parent_pid) do
    send parent_pid, {:ok, "message from the child"}
    exit(:boom)
  end

  def run do
    spawn_monitor(WorkingWithMultipleProcesses, :listen, [self()])

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
# => MESSAGE RECEIVED: message from the child
# .
# Keeps listening

