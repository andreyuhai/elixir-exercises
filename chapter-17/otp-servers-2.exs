# Exercise:OTP-Servers-2
# Extend your stack server with a push interface that adds
# a single value to the top of the stack. This will be implemented
# as a cast.

defmodule Stack do
  use GenServer

  def init(initial_stack) do
    {:ok, initial_stack}
  end

  def handle_call(:pop, _from, []) do
    exit(:boom)
  end

  def handle_call(:pop, _from, [last_element|rest]) do
    {:reply, last_element, rest}
  end

  def handle_cast({:push, item}, current_stack) do
    {:noreply, [item | current_stack]}
  end
end

{:ok, pid} = GenServer.start_link(Stack, [5, "cat", 9])

IO.inspect(GenServer.call(pid, :pop))
# => 5

IO.inspect(GenServer.cast(pid, {:push, "foo"}))
# => :ok

IO.inspect(GenServer.call(pid, :pop))
# => "foo"

IO.inspect(GenServer.call(pid, :pop))
# => "cat"
