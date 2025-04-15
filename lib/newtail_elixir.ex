defmodule NewtailElixir do
  @moduledoc """
  Implements the interface of the lib.
  """

  alias NewtailElixir.Clients.Newtail

  @doc """
  Syncs products or inventories with Newtail.
  The process is asynchronous on the Newtail side, so the function
  returns immediately after sending the request and have no particular
  success or failure body/response to act on.

  ## Parameters
    - `params`: A list of products to sync.
    - `type`: The type of sync to perform. Can be `:products` or `:inventories`.

  ## Returns
    - `{:ok, _string_message}` on success.
    - `{:error, _string_message}` on failure because properties are missing.
    - `{:error, _map}` when request fails. Map contains metadata, endpoint and reason for
    debugging/reporting purposes.
    - `{:unexpected_response, _map}` when the response is not 202 or 422. Map contains response
    body and status code.
  """
  @spec sync(list(), atom()) :: {:ok, binary()} | {:error, binary() | {:error, map()}}
  defdelegate sync(params, type), to: Newtail
end
