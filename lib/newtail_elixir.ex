defmodule NewtailElixir do
  @moduledoc """
  Documentation for `NewtailElixir`.
  """

  alias NewtailElixir.Clients.Newtail

  defdelegate sync_products(params), to: Newtail
end
