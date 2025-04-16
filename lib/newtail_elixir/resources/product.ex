defmodule NewtailElixir.Resources.Product do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @fields [
    :brand,
    :categories,
    :gtins,
    :image_url,
    :metadata,
    :name,
    :parent_sku,
    :product_sku,
    :sellers,
    :tags,
    :url
  ]

  @required_fields @fields --
                     [:brand, :gtins, :image_url, :metadata, :parent_sku, :sellers, :tags]

  @derive {Jason.Encoder, only: @fields}
  embedded_schema do
    field(:brand, :string)
    field(:categories, {:array, :string})
    field(:gtins, {:array, :string})
    field(:image_url, :string)
    field(:metadata, :map)
    field(:name, :string)
    field(:parent_sku, :string)
    field(:product_sku, :string)
    field(:sellers, {:array, :string})
    field(:tags, {:array, :string})
    field(:url, :string)
  end

  def changeset(%__MODULE__{} = product, attrs) do
    product
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
