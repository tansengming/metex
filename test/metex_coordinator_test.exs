defmodule Metex.CoordinatorTest do
  use ExUnit.Case, async: true

  test ".loop" do
    pid = spawn(Metex.Coordinator, :loop, [[], 0])
    assert pid != nil
  end
end