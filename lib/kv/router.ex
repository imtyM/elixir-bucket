defmodule KV.Router do
  @doc """
  Dispatch the given `mod`, `fun`, `args` request
  to the appropriate node based on the `bucket`
  """
  def route(bucket, module, func, args) do
    bucket_first_byte = bucket |> :binary.first

    entry =
      table()
      |> Enum.find(fn {enum, _node} ->
          bucket_first_byte in enum
        end) || no_entry_error(bucket)

    # If the entry node is the current node
    if elem(entry, 1) == node() do
      apply(module, func, args)
    else
      {KV.RouterTasks, elem(entry, 1)}
      |> Task.Supervisor.async(KV.Router, :route, [bucket, module, func, args])
      |> Task.await()
    end
  end

  defp no_entry_error(bucket) do
    raise "could not find entry for #{inspect bucket} in table #{inspect table()}"
  end

  @doc """
  The routing table
  """
  def table do
    [{?a..?m, :"foo@pop-os"}, {?n..?z, :"bar@pop-os"}]
  end
end
