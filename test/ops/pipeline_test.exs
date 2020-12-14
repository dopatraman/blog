defmodule Blog.Ops.PipelineTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Blog.Ops.Pipeline

  test "it kicks off a task pipeline" do
    {:ok, result} =
      Pipeline.add(fn -> {:ok, "hello"} end)
      |> Pipeline.add(fn hello -> {:ok, hello <> "world"} end)
      |> Pipeline.start()

    assert result == "helloworld"
  end

  test "it should break if theres an error" do
    {:error, _} =
      Pipeline.add(fn -> {:ok, "hello"} end)
      |> Pipeline.add(fn _ -> {:error, "Oops"} end)
      |> Pipeline.add(fn _ -> {:ok, "We're back"} end)
      |> Pipeline.start()
  end

  test "it should work with function capture" do
    r = Pipeline.add(fn -> {:ok, "hello world"} end)
    |> Pipeline.add(&IO.inspect/1)
    |> Pipeline.start()

    assert r == "hello world"
  end
end
