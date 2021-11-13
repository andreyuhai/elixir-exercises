# Exercise:OTP-Servers-3
# Give your stack server process a name, and make sure it is accessible
# by that name in IEX.

# Exercise:OTP-Servers-4
# Add the API to your stack module (the functions that wrap the GenServer calls)

# Exercise:OTP-Servers-5
# Implement the terminate callback in your stack handler. Use IO.puts
# to report the arguments it receives.

defmodule Stack do

  def start_link(initial_stack) do
    GenServer.start_link(Stack.Server, initial_stack, name: Stack.Server)
  end

  def pop do
    GenServer.call(Stack.Server, :pop)
  end

  def push(item) do
    GenServer.cast(Stack.Server, {:push, item})
  end
end

defmodule Stack.Server do
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

  def terminate(reason, state) do
    IO.inspect(reason, label: :reason)
    IO.inspect(state, label: :state)
  end
end

# Here we start our stack with empty list
Stack.start_link([])

Stack.push(3)
Stack.push(5)
Stack.push(7)

IO.inspect(Stack.pop())
# => 7

IO.inspect(Stack.pop())
# => 5

IO.inspect(Stack.pop())
# => 3

IO.inspect(Stack.pop())
# reason: :boom
# state: []
