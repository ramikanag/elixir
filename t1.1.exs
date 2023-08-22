defmodule Mapp do
  IO.puts("Time for map fn:")
  st=System.os_time()
  def mapp([head | tail], f) do
    [f.(head) | map(tail, f)]
  end
  et=System.os_time()
  time=et-st
  IO.puts("Start time=#{st}")
  IO.puts("End time=#{et}")
  IO.puts("Total time=#{time}")

  IO.puts("Time for parallel map fn:")
  st=System.os_time()
  def mappar do
    l
    |>Enum.map(&Task.async(fn-> f.(&1)end))
    |>Enum.map(&Task.await/1)
    end
    et=System.os_time()
    time=et-st
    IO.puts("Start time=#{st}")
    IO.puts("End time=#{et}")
    IO.puts("Total time=#{time}")
end
l = 1..10000
f = fn x -> x * x end
