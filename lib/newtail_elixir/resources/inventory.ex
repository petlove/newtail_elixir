defmodule NewtailElixir.Resources.Inventory do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @fields [
    :is_available,
    :price,
    :product_sku,
    :promotional_price,
    :store_id
  ]

  @required_fields @fields -- [:store_id]

  @derive {Jason.Encoder, only: @fields}
  embedded_schema do
    field(:is_available, :boolean)
    field(:price, :float)
    field(:product_sku, :string)
    field(:promotional_price, :float)
    field(:store_id, :string)
  end

  def changeset(%__MODULE__{} = inventory, attrs) do
    inventory
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
