defmodule Mapp do
  start_time=System.os_time()
  def sequential_map([head | tail], function) do
    [function.(head) | sequential_map(tail, function)]
  end
  def sequential_map([], function), do: []
  end_time=System.os_time()
  IO.puts("Total time for sequential map function=#{end_time-start_time}")

  start_time_parallel=System.os_time()
  def parallel_map(list, function) do
    list
    |> Enum.map(&Task.async(fn -> function.(&1) end))
    |> Enum.map(&Task.await/1)
  end
  end_time_parallel=System.os_time()
  IO.puts("Total time for parallel map function=#{end_time_parallel-start_time_parallel}")

  def display_result(list, function) do
    result = sequential_map(list, function)
    IO.puts("Sequential map result: #{result}")

    result2 = parallel_map(result, function)
    IO.puts("Parallel map result: #{result2}")
  end
end

list = 1..10000
function = fn x -> x * x end
Mapp.display_result(list, function)
