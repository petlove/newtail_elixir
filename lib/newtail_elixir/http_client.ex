defmodule NewtailElixir.HttpClient do
  @moduledoc false

  @behaviour NewtailElixir.HttpClientBehaviour

  def post(body, type, opts) do
    url = build_url(type)
    headers = headers(opts)

    http_client().post(url, body, headers) |> handle_response(url)
  end

  defp build_url(:products), do: base_url() <> "/product/bulk/products"
  defp build_url(:inventories), do: base_url() <> "/product/bulk/inventories"

  defp headers(opts) do
    %{
      "content-Type" => "application/json",
      "accept" => "application/json",
      "x-app-id" => opts[:app_id],
      "x-api-key" => opts[:api_key]
    }
  end

  defp handle_response(
         {:ok, %HTTPoison.Response{status_code: status_code, body: body}},
         url
       )
       when status_code in 200..202 do
    cond do
      String.ends_with?(url, "/product/bulk/products") ->
        {:ok, "Products have been enqueued for sync"}

      String.ends_with?(url, "/product/bulk/inventories") ->
        {:ok, "Inventories have been enqueued for sync"}

      true ->
        {:ok, body}
    end
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}, _url) do
    {:unexpected_response, %{status_code: status_code, body: body}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}, url) do
    {:error, %{fingerprint: url, metadata: %{url: url}, reason: reason}}
  end

  defp base_url, do: Application.fetch_env!(:newtail_elixir, :base_url)

  defp http_client, do: Application.get_env(:newtail_elixir, :http_client, HTTPoison)
end
