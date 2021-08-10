defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert registry |> KV.Registry.lookup("shopping") == :error

    registry |> KV.Registry.create("shopping")
    assert {:ok, bucket} = registry |> KV.Registry.lookup("shopping")

    bucket |> KV.Bucket.put("milk", 1)
    assert bucket |> KV.Bucket.get("milk") == 1
  end
end
