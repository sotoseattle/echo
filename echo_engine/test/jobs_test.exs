defmodule JobsTest do
  use ExUnit.Case
  # doctest EchoEngine
  alias EchoEngine.Gtd

  test "basic stuff" do
    {:ok, _pid} = Gtd.start_link(nil)

    Gtd.add_entry("hola")
    Gtd.add_entry("adios")
    all = Gtd.all()

    assert Enum.count(all) == 2
    refute all["1"].done
    refute all["2"].done

    Gtd.toggle("2")
    assert Gtd.all()["2"].done

    Gtd.delete("1")
    all = Gtd.all()
    assert Enum.count(all) == 1
    refute Map.has_key?(all, "1")
    assert Map.has_key?(all, "2")
  end
end
