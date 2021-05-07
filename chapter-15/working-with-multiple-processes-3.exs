defmodule WorkingWithMultipleProcesses do
  import :timer, only: [sleep: 1]
  # Exercise:WorkingWithMultipleProcesses-3
  # Use spawn_link to start a process, and have that process
  # send a message to the parent and then exit immediately. Meanwhile,
  # sleep for 500 ms in the parent, then receive as many messages as are
  # waiting. Trace what you receive. Does it matter that you weren't
  # waiting for the notifications from the child when it exited?

  def listen(parent_pid) do
    send parent_pid, {:ok, "message from the child"}
    exit(:boom)
  end

  def run do
    spawn_link(WorkingWithMultipleProcesses, :listen, [self()])

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
# => ** (EXIT from #PID<0.93.0>) :boom
# Exits after the child exits

