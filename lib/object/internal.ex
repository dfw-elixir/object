defmodule Object.Internal do
  def new do
    spawn(fn -> recv_loop(%{}) end)
  end

  def recv_loop(state) do
    receive do
      {:set, key, val} ->
        state
        |> Map.put(key, val)
        |> recv_loop()

      {:get, pid, ref, key} ->
        val = Map.get(state, key)
        send(pid, {ref, val})
        recv_loop(state)

      {:all, pid, ref} ->
        send(pid, {ref, state})
        recv_loop(state)

      _ ->
        recv_loop(state)
    end
  end
end
