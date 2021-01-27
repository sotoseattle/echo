defmodule EchoEngine.Gtd do
  alias EchoEngine.Entry

  use GenServer

  @name :steve

  defmodule PunchList do
    defstruct counter: 0, jobs: []
    def new, do: %__MODULE__{}
  end

  # CLIENT INTERFACE

  def start_link(_args), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def add_entry(texto),  do: GenServer.call(@name, {:add, texto})

  def all(),             do: GenServer.call(@name, :all)

  def toggle(id),        do: GenServer.call(@name, {:toggle, id})

  def delete(id),        do: GenServer.call(@name, {:delete, id})

  # SERVER CALLBACKS

  def init(:ok), do: {:ok, PunchList.new()}

  def handle_call({:add, texto}, _from, punch_list) do
    i = punch_list.counter + 1
    e = Entry.new(i, texto)

    new_punch_list =
      punch_list
      |> add_new_entry(e)
      |> update_counter(i)

    {:reply, {:ok, e}, new_punch_list}
  end

  def handle_call(:all, _from, %PunchList{jobs: jobs} = punch_list) do
    {:reply, jobs, punch_list}
  end

  def handle_call({:toggle, id}, _from, punch_list) do
    old_e = punch_list.jobs |> Enum.find(&(&1.id == id))
    new_e = %{old_e | done: !old_e.done}
    new_jobs = Enum.map(punch_list.jobs,
                 fn e -> if e == old_e, do: new_e, else: e end)

    {:reply, {:ok, new_e}, %{punch_list | jobs: new_jobs}}
  end

  def handle_call({:delete, id}, _from, %PunchList{jobs: jobs} = punch_list) do
    del_e = Enum.find(jobs, &(&1.id == id))
    {:reply, {:ok, del_e}, %PunchList{punch_list | jobs: List.delete(jobs, del_e)}}
  end

  defp add_new_entry(%PunchList{jobs: jobs} = punch_list, e) do
    %PunchList{punch_list | jobs: [e | jobs]}
  end

  defp update_counter(%PunchList{} = punch_list, i) do
    %PunchList{punch_list | counter: i}
  end

  defp substitute_jobs(new_e, old_e, jobs) do
    jobs |> Enum.map(fn e -> if e == old_e, do: new_e, else: e end)
  end

end
