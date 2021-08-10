defmodule KV.Registry do
  use GenServer

  ## Client

  @doc """
  Starts the registry
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks for the bucket pid for `name` stored in the `server`

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise
  """
  def lookup(server, name) do
    server |> GenServer.call({:lookup, name})
  end

  @doc """
  Ensures there is a bucket with the given `name` in the `server`
  """
  def create(server, name) do
    server |> GenServer.cast({:create, name})
  end
  ## Sever

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  @impl true
  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = KV.Bucket.start_link([])
      {:noreply, Map.put(names, name, bucket)}
    end
  end
end
