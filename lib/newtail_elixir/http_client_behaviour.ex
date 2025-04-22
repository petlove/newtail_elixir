defmodule NewtailElixir.HttpClientBehaviour do
  @moduledoc "Http client behaviour."

  @typep body :: nonempty_list()
  @typep type :: :products | :inventories
  @typep opts :: keyword()

  @callback post(body, type, opts) ::
              {:ok, binary()}
              | {:error, binary() | {:error, map()}}
              | {:unexpected_response, map()}
end
