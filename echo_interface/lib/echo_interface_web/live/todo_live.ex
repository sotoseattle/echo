defmodule EchoInterfaceWeb.TodoLive do
  use EchoInterfaceWeb, :live_view
  alias EchoEngine.{Gtd, GtdSupervisor}
  alias EchoInterfaceWeb.TodoLive.EntryFormData

  def mount(_params, _session, socket) do
    GtdSupervisor.start_new_list()
    {:ok, assign(socket, mounting_params()), temporary_assigns: [estado: []]}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, validate(socket, params)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    {:noreply, save(socket, params)}
  end

  def handle_event("toggle", %{"index" => idx}, socket) do
    {:noreply, toggle(socket, idx)}
  end

  def handle_event("delete", %{"index" => idx}, socket) do
    {:noreply, delete(socket, idx)}
  end

  # PRIVATE FUNCTIONS

  defp validate(socket, params) do
    changeset = new_changeset(socket.assigns.texto, params)
    assign(socket, changeset: changeset)
  end

  defp save(socket, params) do
    changeset = new_changeset(socket.assigns.texto, params)
    with true <- changeset.valid?,
         {:ok, entry} <- Gtd.add_entry(changeset.changes.texto)
    do
      assign(socket, texto: "", changeset: empty_changeset(),
                     estado: [entry | socket.assigns.estado])
    else err ->
      assign(socket, changeset: changeset)
    end
  end

  defp toggle(socket, idx) do
    with {:ok, new_e} <- Gtd.toggle(idx) do
      assign(socket, estado: [new_e | socket.assigns.estado])
    else
      err -> socket
    end
  end

  defp delete(socket, idx) do
    with {:ok, del_e} <- Gtd.delete(idx) do
      assign(socket, estado: [%{del_e | meta: :hidden} | socket.assigns.estado])
    else
      err -> socket
    end
  end

  defp mounting_params(), do:
    %{texto: "", estado: Gtd.all(), changeset: empty_changeset()}

  defp new_changeset(texto, params), do:
    texto |> EntryFormData.new() |> EntryFormData.change(params)

  defp empty_changeset(), do:
    new_changeset("", %{})

end
