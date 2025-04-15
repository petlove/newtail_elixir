defmodule NewtailElixir.Clients.Newtail do
  @moduledoc """
  Implements the actual sync logic.
  """

  @behaviour NewtailElixir.Clients.NewtailBehaviour

  def sync(body, type) do
    encoded_body = Jason.encode!(body)
    url = build_url(type)

    url
    |> http_client().post(encoded_body, headers())
    |> handle_response(url)
  end

  defp build_url(:products), do: newtail_config(:base_url) <> "/product/bulk/products"
  defp build_url(:inventories), do: newtail_config(:base_url) <> "/product/bulk/inventories"

  defp handle_response({:ok, %HTTPoison.Response{status_code: 202}}, _url) do
    {:ok, "Products have been enqueued for sync"}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 422, body: body}}, _url) do
    missing_properties =
      body
      |> Jason.decode!()
      |> Enum.map(fn %{params: %{missingProperty: property}} -> property end)
      |> Enum.uniq()
      |> Enum.join(", ")

    {:error, "The following properties are missing: #{missing_properties}"}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status, body: body}}, _url) do
    {:unexpected_response, %{status: status, body: Jason.decode!(body)}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}, url) do
    endpoint = String.replace(url, ~r/\?.+$/, "")
    metadata = %{url: url}

    {:error, %{fingerprint: endpoint, metadata: metadata, reason: reason}}
  end

  defp headers do
    %{
      "content-Type" => "application/json",
      "accept" => "application/json",
      "x-app-id" => newtail_config(:app_id),
      "x-api-key" => newtail_config(:api_key)
    }
  end

  defp newtail_config(key), do: Application.get_env(:newtail_elixir, key)
  defp http_client, do: Application.get_env(:newtail_elixir, :http_client, HTTPoison)
end
