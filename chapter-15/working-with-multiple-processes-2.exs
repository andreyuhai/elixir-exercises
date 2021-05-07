defmodule WorkingWithMultipleProcesses do
  require IEx

  # Exercise:WorkingWithMultipleProcesses-2
  # Write a program that spawns two processes and then passes each
  # a unique token (for example "fred", "betty"). Have them send
  # the tokens back
  #
  # - Is the order in which the replies are received deterministic in theory?
  #   In practice?
  # - If either answer is no, how could you make it so?

  def listen do
    receive do
      {sender, msg} ->
        send sender, {:ok, msg, self()}
        listen()
    end
  end

  def run do
    pids = for p <- 1..2, into: [], do: spawn(WorkingWithMultipleProcesses, :listen, [])

    pids
    |> Enum.zip(["fred", "betty"])
    |> Stream.cycle()
    |> Enum.take(10)
    |> Stream.each(&IO.inspect/1)
    |> Enum.each(&send_msg/1)

    main_listen()
  end

  def send_msg({pid, msg}), do: send pid, {self(), msg}

  def main_listen do
    receive do
      {:ok, msg, sender} ->
        IO.puts "I've received #{msg}"
        main_listen()
    end
  end
end

WorkingWithMultipleProcesses.run()
# =>
# {#PID<0.113.0>, "foo"}
# {#PID<0.114.0>, "betty"}
# {#PID<0.113.0>, "foo"}
# {#PID<0.114.0>, "betty"}
# {#PID<0.113.0>, "foo"}
# {#PID<0.114.0>, "betty"}
# {#PID<0.113.0>, "foo"}
# {#PID<0.114.0>, "betty"}
# {#PID<0.113.0>, "foo"}
# {#PID<0.114.0>, "betty"}
# I've received foo
# I've received betty
# I've received foo
# I've received betty
# I've received foo
# I've received betty
# I've received foo
# I've received betty  !! \  Not in order
# I've received betty  !! /
# I've received foo

