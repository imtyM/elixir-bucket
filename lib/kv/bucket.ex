defmodule KV.Bucket do
  use Agent

  @doc """
  Starts a new Bucket
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the Bucket by "KEY"
  """
  def get(bucket, key) do
    bucket
    |> Agent.get(&Map.get(&1, key))
  end

  @doc """
  Puts the value for a given ket into the bucket
  """
  def put(bucket, key, value) do
    bucket
    |> Agent.update(&Map.put(&1, key, value))
  end

  @doc """
  Deletes key from bucket, returns the current value of key
  """
  def delete(bucket, key) do
    bucket
    |> Agent.get_and_update(&Map.pop(&1, key))
  end
end
