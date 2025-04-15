defmodule NewtailElixir.Clients.NewtailBehaviour do
  @moduledoc "Newtail client behaviour."

  @typep body :: nonempty_list()

  @callback sync_products(body) :: {:ok, binary()} | {:error, binary()}
end
