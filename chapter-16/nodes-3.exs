# Exercise:Nodes-3
# Alter the code so that successive ticks are sent to each registered client
# (so the first goes to the client, the second to the next client and so on).
# Once the last client receives a tick, the process starts back at the
# first. The solution should deal with new clients being added at any time.
defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0, 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def generator([], _, _) do
    receive do
      {:register, pid} ->
        IO.puts "registering #{inspect pid}"
        generator([pid], 1, 0)
    end
  end

  def generator(clients, num_clients, index) when num_clients == index, do: generator(clients, num_clients, 0)
  def generator(clients, num_clients, index) do
    receive do
      {:register, pid} ->
        IO.puts "registering #{inspect pid}"
        generator([pid | clients], num_clients + 1, index)
    after
      @interval ->
        clients
        |> Enum.at(index)
        |> send({:tick})

        generator(clients, num_clients, index + 1)
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts "tock in client"
        receiver()
    end
  end
end
