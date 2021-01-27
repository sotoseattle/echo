defmodule EchoInterfaceWeb.TodoLive.EntryFormData do
  use Ecto.Schema
  alias EchoInterfaceWeb.TodoLive.EntryFormData

  defstruct texto: ""
  @types %{texto: :string}

  def new(), do: %EntryFormData{texto: ""}
  def new(str), do: %EntryFormData{texto: str}

  def change(form, params) do
    {form, @types}
    |> Ecto.Changeset.cast(params, Map.keys(@types))
    |> Ecto.Changeset.validate_length(:texto, min: 3, max: 142)
    |> Map.put(:action, :validate)
  end
end
