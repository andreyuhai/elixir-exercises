defmodule WordFinder do
  # Exercise:WorkingWithMultipleProcesses-9
  # Take this scheduler code and update it to let you run a function
  # that finds the number of times the word "cat" appears in each file
  # in a given directory. Run one server process per file. Can you write
  # it as a more generalized scheduler?
  #
  # Run your code on a directory with a reasonable number of files (maybe
  # around 100) so you can experiment with the effects of concurrency.
  #
  # Answer:
  #   I'have also written a module to do the same thing in a synchronous way.
  #   So we can compare the results.
  #   You can find the module SynchronousWordFinder below.
  #
  #   I've created 100 files of size 5 MB with random text using the bash one liner below
  #   $ for i in $(seq 1 100); do < /dev/urandom tr -dc "\t\n [a-z]" | head -c5000000 > file$i.txt; done
  #
  #   And then using the two different approaches (concurrent and synchronous) I've tried
  #   to find the word "cat" in those files.
  #
  #   You can see the results at the end of the file. It can be seen
  #   that with the concurrent way we were able to do the same thing in
  #   less than half the time that was spent doing it the synchronous way.
  #
  #   To reproduce just run this file with elixir in a directory with your files.
  #   `elixir foo.exs`


  def run(scheduler, file_path, word) do
    send scheduler, {:answer, self(), word, file_path, find_num_words(word, file_path)}
  end

  defp find_num_words(word, file_path) do
    with {:ok, content} <- File.read(file_path),
         matches <- :binary.matches(content, word) do
      length(matches)
    end
  end
end

defmodule Scheduler do

  def run(module, func, word) do
    File.ls!()
    |> Enum.filter(fn file -> not File.dir?(file) end)
    |> Enum.map(fn file -> spawn(module, func, [self(), file, word]) end)
    |> receive_answers([])
  end

  defp receive_answers([], results), do: results

  defp receive_answers(processes, results) do
    receive do
      {:answer, pid, word, file_path, num_words} ->
        receive_answers(List.delete(processes, pid), [{word, file_path, num_words} | results])
    end
  end
end

defmodule SynchronousWordFinder do
  def run(word) do
    File.ls!()
    |> Enum.filter(fn file -> not File.dir?(file) end)
    |> Enum.map(fn file -> find_num_words(word, file) end)
  end

  defp find_num_words(word, file_path) do
    with {:ok, content} <- File.read(file_path),
         matches <- :binary.matches(content, word) do
      length(matches)
    end
  end
end

IO.puts("Running concurrently")

Enum.each(1..10, fn num_processes ->
  {time, result} = :timer.tc(Scheduler, :run, [WordFinder, :run, "cat"])

  if num_processes == 1 do
    IO.puts inspect result
    IO.puts("\n#\ttime(s)")
  end
  :io.format("~2B\t~.2f~n", [num_processes, time/1000000.0])
end)

IO.puts("\nRunning synchronously")

Enum.each(1..10, fn num_processes ->
  {time, result} = :timer.tc(SynchronousWordFinder, :run, ["cat"])

  if num_processes == 1 do
    IO.puts inspect result
    IO.puts("\n#\ttime(s)")
  end
  :io.format("~2B\t~.2f~n", [num_processes, time/1000000.0])
end)

# =>
#Running concurrently
#[{"cat", "file72.txt", 173}, {"cat", "file81.txt", 156}, {"cat", "file47.txt", 172}, {"cat", "file21.txt", 158}, {"cat", "file63.txt", 185}, {"cat", "file25.txt", 182}, {"cat", "file56.txt", 162}, {"cat", "file64.txt", 162}, {"cat", "file74.txt", 162}, {"cat", "file26.txt", 176}, {"cat", "file9.txt", 171}, {"cat", "file85.txt", 184}, {"cat", "file84.txt", 156}, {"cat", "file8.txt", 186}, {"cat", "file27.txt", 173}, {"cat", "file13.txt", 165}, {"cat", "file41.txt", 171}, {"cat", "file12.txt", 170}, {"cat", "file4.txt", 152}, {"cat", "file15.txt", 172}, {"cat", "file10.txt", 179}, {"cat", "file55.txt", 156}, {"cat", "file22.txt", 174}, {"cat", "file70.txt", 177}, {"cat", "file11.txt", 158}, {"cat", "file34.txt", 188}, {"cat", "file20.txt", 183}, {"cat", "config-err-ycUa02", 0}, {"cat", "file43.txt", 194}, {"cat", "file75.txt", 183}, {"cat", "file96.txt", 171}, {"cat", "file45.txt", 181}, {"cat", "file30.txt", 162}, {"cat", "file68.txt", 177}, {"cat", "file80.txt", 185}, {"cat", "file39.txt", 168}, {"cat", "file88.txt", 153}, {"cat", "file33.txt", 150}, {"cat", "file99.txt", 158}, {"cat", "file89.txt", 155}, {"cat", "file86.txt", 173}, {"cat", "file53.txt", 161}, {"cat", "file7.txt", 166}, {"cat", "file1.txt", 158}, {"cat", "file31.txt", 143}, {"cat", "file92.txt", 160}, {"cat", "file50.txt", 167}, {"cat", "file29.txt", ...}, {"cat", ...}, {...}, ...]

##	time(s)
# 1	0.45
# 2	0.39
# 3	0.40
# 4	0.41
# 5	0.40
# 6	0.42
# 7	0.39
# 8	0.39
# 9	0.39
#10	0.39

#Running synchronously
#[149, 176, 206, 168, 159, 155, 177, 160, 173, 167, 166, 179, 158, 159, 162, 156, 178, 179, 200, 177, 0, 190, 156, 167, 145, 174, 167, 180, 163, 180, 165, 165, 166, 187, 166, 184, 146, 147, 150, 168, 177, 173, 171, 0, 185, 160, 181, 165, 166, 170, ...]

##	time(s)
# 1	1.50
# 2	1.44
# 3	1.46
# 4	1.46
# 5	1.50
# 6	1.51
# 7	1.48
# 8	1.52
# 9	1.51
#10	1.45

