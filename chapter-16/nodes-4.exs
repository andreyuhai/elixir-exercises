# This code has been taken from:
# https://github.com/carlos4ndre/elixir-exercises/blob/master/chapter-15/nodes-4/ring.ex
#
# I think this is a brilliant solution but as far as I understood we are
# supposed to implement solve this problem by using timeout in Client's receive block.
# TODO: Implement in your own way.
# ----------------------------------------------------------------------------------------
#
# Exercise:Node-4
# The ticker process in this chapter is a central server that sends
# events to registered clients. Reimplement this as a ring of clients.
# A client sends a tick to the next client in the ring. After 2 seconds,
# that client sends a tick to its next client.
#
# When thinking about how to add clients to the ring, remember to deal
# with the case where a client's receive loop times out just as you're
# adding a new process. What does this say about who has to be responsible
# for updating the links?
defmodule Ring do
  @name :ring
  @interval 5000

  def start do
    pid = spawn(__MODULE__, :receiver, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def update_clients_links(clients) do
    case clients do
      [client | other_clients] ->
        next_client = List.first(other_clients)
        send(client, {:update_link, next_client})
        update_clients_links(other_clients)
      [] ->
        IO.puts "Clients' links have been updated."
    end
  end

  def send_tick(pid) do
    if pid do
      send(pid, {:tick})
    end
  end

  def receiver(clients) do
    receive do
      {:register, pid} ->
        IO.puts "Registering #{inspect pid}"
        new_clients = clients ++ [pid]
        IO.puts "Update clients' links"
        update_clients_links(new_clients)
        receiver(new_clients)
      {:tick} ->
        first_client = List.first(clients)
        send_tick(first_client)
        receiver(clients)
    after
      @interval ->
        send(self(), {:tick})
        receiver(clients)
    end
  end
end

defmodule Client do
  def join do
    pid = spawn(__MODULE__, :receiver, [[]])
    Ring.register(pid)
  end

  def receiver(next_client) do
    receive do
      {:update_link, next_client} ->
        receiver(next_client)
      {:tick} ->
        IO.puts "tick on node #{inspect(self())}"
        :timer.sleep(2000)
        send_tick(next_client)
        receiver(next_client)
    end
  end

  defp send_tick(next_client) do
    if next_client do
      send next_client, {:tick}
    end
  end
end

# From one iex node, run Ring.start and Client.join
# And from other iex nodes connected to the Ring node, run Client.join
