defmodule EchoEngine.GtdSupervisor do
  use DynamicSupervisor

  alias EchoEngine.Gtd

  def start_link(_options) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_new_list() do
    spec = %{id: Gtd, start: {Gtd, :start_link, ["pepe"]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
