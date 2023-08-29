defmodule Mapp do
  def sequential_map([head | tail], function) do Enum.reverse([head|tail])
    [function.(head) | sequential_map(tail, function)]
  end
  def sequential_map([], _function), do: []

  def parallel_map(list, function) do
    list
    |> Mapp.sequential_map(&Task.async(fn -> function.(&1) end))
    |> Mapp.sequential_map(&Task.await/1)
  end

  def display_result(list, function) do
    start_time=System.monotonic_time()
    result = sequential_map(list, function)
    IO.puts("Total time for sequential map function=#{System.monotonic_time()-start_time}")
    IO.puts("Sequential map result: #{result}")

    start_time_parallel=System.monotonic_time()
    result2 = parallel_map(result, function)
    IO.puts("Total time for parallel map function=#{System.monotonic_time()-start_time_parallel}")
    IO.puts("Parallel map result: #{result2}")
  end
end
Mapp.display_result(1..10000, fn x -> x * x end)
