# Exercise:OTP-Servers-1
# You're going to start creating a server that implements a stack.
# The call that initializes your stack will pass in a list of the initial
# stack contents.
#
# For now, implement only the pop interface. It's acceptable for your server
# to crash if sommeone tries to pop from an empty stack.
#
# For example, if initialized with [5, "cat", 9], successive calls to pop
# will return 5, "cat", 9.

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
end

{:ok, pid} = GenServer.start_link(Stack, [5, "cat", 9])

IO.inspect(GenServer.call(pid, :pop))
# => 5

IO.inspect(GenServer.call(pid, :pop))
# => "cat"

IO.inspect(GenServer.call(pid, :pop))
# => 9

IO.inspect(GenServer.call(pid, :pop))
# 22:22:29.460 [error] GenServer #PID<0.100.0> terminating
# ** (stop) :boom
#     nodes-4.exs:20: Stack.handle_call/3
#     (stdlib 3.13) gen_server.erl:706: :gen_server.try_handle_call/4
#     (stdlib 3.13) gen_server.erl:735: :gen_server.handle_msg/6
#     (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
# Last message (from #PID<0.95.0>): :pop
# State: []
# Client #PID<0.95.0> is alive

#     (stdlib 3.13) gen.erl:208: :gen.do_call/4
#     (elixir 1.12.2) lib/gen_server.ex:1021: GenServer.call/3
#     nodes-4.exs:39: (file)
#     (elixir 1.12.2) src/elixir_compiler.erl:75: :elixir_compiler.dispatch/4
#     (elixir 1.12.2) src/elixir_compiler.erl:60: :elixir_compiler.compile/3
#     (elixir 1.12.2) src/elixir_lexical.erl:15: :elixir_lexical.run/3
#     (elixir 1.12.2) src/elixir_compiler.erl:18: :elixir_compiler.quoted/3
#     (elixir 1.12.2) lib/code.ex:1261: Code.require_file/2
