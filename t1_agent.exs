defmodule Mapp do
  use Agent
  def sequential_map([head|tail],function) do
    [function.(head)|sequential_map(tail,function)]
  end
  def sequential_map([],_function), do: []

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def put(pid, list) do
    sequential_map(list, fn x ->
      Agent.update(pid, fn state ->
        &Mapp.sequential_map(&1,x,fn x->x*x end)   #&Map.put(&1,x,x*x)
      end)
    end)
  end

  def get(pid) do
    Agent.get(pid, fn state ->state end)
  end


  def parallel_map(list,_function) do
    pid=start_link()
    _pid=put(pid,list)
  end

  def display_result(list, function) do
    start_time = System.monotonic_time()
    result = sequential_map(list, function)
    IO.puts("Sequential map result: #{result}")
    IO.puts("Total time for sequential map function=#{System.monotonic_time()-start_time}")

    start_time_parallel = System.monotonic_time()
    pid=parallel_map(list, function)
    result2 =get(pid)
    IO.puts("Parallel map result: #{result2}")
    IO.puts("Total time for parallel map function=#{System.monotonic_time()-start_time_parallel}")
  end
end

Mapp.display_result(1..10000, fn x -> x*x end)
