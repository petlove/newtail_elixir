defmodule NewtailElixir.Resources.Placement do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @derive Jason.Encoder
  embedded_schema do
    field(:quantity, :integer)
    field(:types, {:array, :string})
  end

  @valid_types ~w(product banner)

  def changeset(%__MODULE__{} = placement, attrs) do
    placement
    |> cast(attrs, [:quantity, :types])
    |> validate_required([:quantity, :types])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_subset(:types, @valid_types)
  end
end
