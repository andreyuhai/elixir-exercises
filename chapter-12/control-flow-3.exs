defmodule ControlFlow do
  def ok!({:ok, data}), do: data
  def ok!({other, data}), do: raise "Your tuple doesn't have :ok, it has {#{other}, #{data}}"
end

IO.puts ControlFlow.ok!({:ok, 123})
# => 123

IO.puts ControlFlow.ok!({:error, 123})
# =>
# ** (RuntimeError) Your tuple doesn't have :ok, it has {error, 123}
#    control-flow-3.exs:3: ControlFlow.ok!/1
#    control-flow-3.exs:9: (file)
#    (elixir 1.11.4) lib/code.ex:931: Code.require_file/2
