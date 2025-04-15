defmodule NewtailElixir do
  @moduledoc """
  Implements the interface of the lib.
  """

  alias NewtailElixir.Clients.Newtail

  @doc """
  Syncs products or inventories with Newtail.

  ## Parameters
    - `params`: A list of products to sync.
    - `type`: The type of sync to perform. Can be `:products` or `:inventories`.

  ## Returns
    - `{:ok, binary()}` on success.
    - `{:error, binary()}` on failure.
  """
  @spec sync(list(), atom()) :: {:ok, binary()} | {:error, binary()}
  defdelegate sync(params, type), to: Newtail
end
