defmodule NewtailElixir.HttpClient do
  @moduledoc false

  @behaviour NewtailElixir.HttpClientBehaviour

  def post(body, type, opts) do
    url = build_url(type, opts)
    headers = headers(opts)

    http_client().post(url, body, headers) |> handle_response(url)
  end

  defp build_url(:products, _opts), do: base_url() <> "/product/bulk/products"
  defp build_url(:inventories, _opts), do: base_url() <> "/product/bulk/inventories"
  defp build_url(:ads, opts), do: base_url() <> "/v1/rma/#{opts[:publisher_id]}"

  defp headers(opts) do
    %{
      "content-Type" => "application/json",
      "accept" => "application/json",
      "x-app-id" => opts[:app_id],
      "x-api-key" => opts[:api_key]
    }
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 202}}, _url) do
    {:ok, "Products have been enqueued for sync"}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}, _url) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}, _url) do
    {:unexpected_response, %{status_code: status_code, body: Jason.decode!(body)}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}, url) do
    {:error, %{fingerprint: url, metadata: %{url: url}, reason: reason}}
  end

  defp base_url, do: Application.fetch_env!(:newtail_elixir, :base_url)

  defp http_client, do: Application.get_env(:newtail_elixir, :http_client, HTTPoison)
end
