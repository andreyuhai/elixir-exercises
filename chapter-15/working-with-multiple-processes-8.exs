defmodule FibSolver do
  # Exercise:WorkingWithMultipleProcesses-8
  # Run the Fibonacci code on your machine. Do you get comparable timings?
  # If your machine has multiple cores and/or processors, do you see
  # improvements in the timing as we increase the application's concurrency?
  #
  # You can see the results at the end of this file.

  def fib(scheduler) do
    send scheduler, {:ready, self()}

    receive do
      {:fib, n, client} ->
        send client, {:answer, n, fib_calc(n), self()}
        fib(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)
end


defmodule Scheduler do

  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [next|tail] = queue
        send pid, {:fib, next, self()}
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end
end


to_process = List.duplicate(37, 20)

Enum.each(1..10, fn num_processes ->
  {time, result} = :timer.tc(Scheduler, :run, [num_processes, FibSolver, :fib, to_process])

  if num_processes == 1 do
    IO.puts inspect result
    IO.puts("\n#\ttime(s)")
  end
  :io.format("~2B\t~.2f~n", [num_processes, time/1000000.0])
end)

# =>
# [{37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}, {37, 24157817}]

#	# time(s)
# 1	19.00
# 2	11.77
# 3	10.56
# 4	9.76
# 5	9.41
# 6	9.62
# 7	9.58
# 8	9.49
# 9	9.27
#10	9.51

