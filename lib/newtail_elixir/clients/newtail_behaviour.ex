defmodule NewtailElixir.Clients.NewtailBehaviour do
  @moduledoc "Newtail client behaviour."

  @typep body :: nonempty_list()
  @typep type :: :products | :inventories

  @callback sync(body, type) :: {:ok, binary()} | {:error, binary() | {:error, map()}} | {:unexpected_response, map()}
end
