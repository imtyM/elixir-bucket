defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
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
end
