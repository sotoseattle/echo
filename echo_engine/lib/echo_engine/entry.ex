defmodule EchoEngine.Entry do
  defstruct [
    id: nil,
    texto: "",
    done: false,
    qualifier: :normal,
    meta: []
  ]

  def new(idx, text) when is_integer(idx) do
    %__MODULE__{
      id: Integer.to_string(idx),
      texto: text}
  end

  def new(idx, text) when is_binary(idx) do
    %__MODULE__{
      id: idx,
      texto: text}
  end

  def toggle(%__MODULE__{done: true} = entry), do:
    Map.put(entry, :done, false)
  def toggle(%__MODULE__{done: false} = entry), do:
    Map.put(entry, :done, true)

end
