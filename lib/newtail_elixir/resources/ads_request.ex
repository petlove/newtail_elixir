defmodule NewtailElixir.Resources.AdsRequest do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias NewtailElixir.Resources.Placement

  @fields [
    :session_id,
    :user_id,
    :channel,
    :context,
    :term,
    :brand_name,
    :category_name,
    :placements,
    :tags
  ]

  @required_fields @fields -- [:term, :brand_name, :user_id, :tags, :category_name]

  @derive {Jason.Encoder, only: @fields}
  embedded_schema do
    field(:session_id, :string)
    field(:user_id, :string)
    field(:channel, :string)
    field(:context, :string)
    field(:term, :string)
    field(:category_name, :string)
    field(:product_sku, :string)
    field(:brand_name, :string)
    field(:placements, :map)
    field(:tags, {:array, :string})
  end

  def changeset(%__MODULE__{} = product, attrs) do
    product
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_context_data()
    |> validate_placements()
  end

  defp validate_context_data(%{changes: %{context: "search"}} = changeset) do
    changeset
    |> validate_required([:term])
  end

  defp validate_context_data(%{changes: %{context: "brand_page"}} = changeset) do
    changeset
    |> validate_required([:brand_name])
  end

  defp validate_context_data(%{changes: %{context: "category"}} = changeset) do
    changeset
    |> validate_required([:category_name])
  end

  defp validate_context_data(changeset), do: changeset

  defp validate_placements(changeset) do
    case get_change(changeset, :placements) do
      nil ->
        changeset

      placements_map when is_map(placements_map) ->
        invalids = placements_map |> Enum.flat_map(&validate_placement/1)

        if invalids == [] do
          changeset
        else
          add_error(changeset, :placements, "invalid placements", details: invalids)
        end

      _ ->
        add_error(changeset, :placements, "must be a map")
    end
  end

  defp validate_placement({name, data}) do
    changeset = Placement.changeset(%Placement{}, data)

    if changeset.valid? do
      []
    else
      [{name, changeset.errors}]
    end
  end
end
