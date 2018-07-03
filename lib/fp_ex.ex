defmodule FpEx do
  def identity(v), do: v
  def always(_, v), do: v
  def map(v, f), do: f.(v)

  def curry(f), do: curry(f, :erlang.fun_info(f)[:arity], [])
  defp curry(f, 0, args), do: Kernel.apply(f, args)
  defp curry(f, arity, args), do: &(curry(f, arity - 1, [&1 | args]))

  def partial(f, v), do: partial(f, v, :erlang.fun_info(f)[:arity])
  defp partial(f, _, 0), do: f.()
  defp partial(f, v, 1), do: f.(v)
  defp partial(f, v, _), do: curry(f).(v)

  def partial_all(v, []), do: v
  def partial_all(f, [arg | rest]), do: partial_all(partial(f, arg), rest)
end
