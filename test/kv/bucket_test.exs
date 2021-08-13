defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!({KV.Bucket, []})
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "#Delete deletes the key in the bucket, returns its value", %{bucket: bucket} do
    bucket |> KV.Bucket.put("milk", 3)
    assert bucket |> KV.Bucket.get("milk") == 3

    assert bucket |> KV.Bucket.delete("milk") == 3
    assert bucket |> KV.Bucket.get("milk") == nil
  end

  test "Bucket is just a process that can be stopped", %{bucket: bucket} do
    assert Process.alive?(bucket) == true

    Process.exit(bucket, :terminate)

    assert Process.alive?(bucket) == false
  end
end
