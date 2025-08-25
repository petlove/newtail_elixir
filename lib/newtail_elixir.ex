defmodule NewtailElixir do
  @moduledoc """
  Implements the interface of the lib.
  """

  @type type :: :products | :inventories

  alias NewtailElixir.HttpClient
  alias NewtailElixir.Resources.{AdsRequest, Inventory, Product}

  @doc """
  Syncs products or inventories with Newtail.
  The process is asynchronous on the Newtail side, so the function
  returns immediately after sending the request and have no particular
  success or failure body/response to act on.

  ## Parameters
    - `params`: A list of products or inventories to sync.
    - `opts`: Options for the request. Values for `app_id` and `api_key` are expected.

  ## Returns
    - `{:ok, _string_message}` on success.
    - `{:error, _string_message}` when the changeset validation fails. The error message contains the invalid params.
    - `{:error, _map}` when request fails. Map url and reason for debugging/reporting purposes.
    - `{:unexpected_response, _map}` when the response is not 202 or 422. Map contains response
    body and status code.
  """
  @spec sync(list(), type, keyword()) :: {:ok, binary()} | {:error, binary() | {:error, map()}}
  def sync(params, type, opts \\ []) do
    changesets = validate_changesets(params, type)

    case Enum.all?(changesets, & &1.valid?) do
      true ->
        params |> Jason.encode!() |> HttpClient.post(type, opts)

      false ->
        invalid_params = format_invalid_changesets(changesets)

        {:error, "The following params are invalid: #{inspect(invalid_params)}"}
    end
  end

  defp validate_changesets(params, :products),
    do: Enum.map(params, &Product.changeset(%Product{}, &1))

  defp validate_changesets(params, :inventories),
    do: Enum.map(params, &Inventory.changeset(%Inventory{}, &1))

  defp format_invalid_changesets(changesets) do
    changesets
    |> Enum.filter(&(!&1.valid?))
    |> Enum.map(fn changeset ->
      Enum.map(changeset.errors, fn {key, {message, _}} -> "#{key}: #{message}" end)
    end)
  end

  @doc """
  Requests ads to fill the ad spaces (`placements`).

  ## Parameters
    - `params`: A map of parameters. Check the VTEX Ads API docs for the required values.
    - `opts`: Options for the request. Values for `app_id`, `api_key` and `publisher_id` are expected.

  ## Returns
    - `{:ok, string_message}` on success.
    - `{:error, string_message}` when the changeset validation fails. The error message contains the invalid params.
    - `{:error, map}` when request fails. Map url and reason for debugging/reporting purposes.
    - `{:unexpected_response, map}` when the response is not 200 or 422. Map contains response body and status code.
  """
  @spec sync(map(), type, keyword()) :: {:ok, binary()} | {:error, binary() | {:error, map()}}
  def query_ads(params, opts \\ []) do
    changeset = AdsRequest.changeset(%AdsRequest{}, params)

    case changeset.valid? do
      true ->
        params |> Jason.encode!() |> HttpClient.post(:ads, opts)

      false ->
        invalid_params = format_invalid_changesets(List.wrap(changeset))

        {:error, "The following params are invalid: #{inspect(invalid_params)}"}
    end
  end
end
