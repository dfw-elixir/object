defmodule Object do
  @moduledoc """
  Documentation for Object.
  """

  defstruct pid: nil

  @behaviour Access

  def new do
    pid = Object.Internal.new()
    %__MODULE__{pid: pid}
  end

  def set(object, key, val) do
    send(object.pid, {:set, key, val})
    object
  end

  def get(object, key) do
    ref = :erlang.make_ref()
    send(object.pid, {:get, self(), ref, key})

    receive do
      {^ref, val} -> val
    after
      5_000 ->
        raise "oops"
    end
  end

  def all(object) do
    ref = :erlang.make_ref()
    send(object.pid, {:all, self(), ref})

    receive do
      {^ref, state} -> state
    after
      5_000 ->
        raise "oops"
    end
  end

  def fetch(object, key) do
    {:ok, get(object, key)}
  end
end

defimpl Inspect, for: Object do
  import Inspect.Algebra

  def inspect(object, opts) do
    object
    |> Object.all()
    |> to_doc(opts)
  end
end
