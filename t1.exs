defmodule Pm do
  def map(l,f) do
    Enum.map(l,f)
  end
  def parallelmod(l,f) do
    l
    |>Enum.map(&Task.async(fn-> f.(&1)end))
    |>Enum.map(&Task.await/1)
  end
end
l=1..10000
f=fn x->x*x end
IO.puts("Time for map fn:")
st=:os.system_time(:millisecond)
Pm.map(l,f)
et=:os.system_time(:millisecond)
time=et-st
IO.puts("start time=#{st}")
IO.puts("end time=#{et}")
IO.puts("total time=#{time}")

IO.puts("Time for parallel map fn:")
st=:os.system_time(:millisecond)
Pm.parallelmod(l,f)
et=:os.system_time(:millisecond)
time=et-st
IO.puts("start time=#{st}")
IO.puts("end time=#{et}")
IO.puts("total time=#{time}")
