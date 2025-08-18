defmodule NewtailElixirTest do
  use ExUnit.Case, async: true

  import Mox

  alias NewtailElixir

  setup :verify_on_exit!

  describe "sync/3 when synching products" do
    setup do
      valid_opts = [
        app_id: "test_app_id",
        api_key: "test_api_key"
      ]

      valid_params = [
        %{
          product_sku: "product_sku",
          name: "Product A",
          url: "product_url",
          categories: ["category1", "category2"]
        }
      ]

      %{valid_opts: valid_opts, valid_params: valid_params}
    end

    test "returns {:error, changeset errors} on changeset validation errors", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      invalid_params =
        valid_params ++
          [
            %{url: "product_url", categories: ["category1", "category2"]},
            %{product_sku: "product_sku2"}
          ]

      assert {:error,
              "The following params are invalid: [[\"name: can't be blank\", \"product_sku: can't be blank\"], [\"categories: can't be blank\", \"name: can't be blank\", \"url: can't be blank\"]]"} ==
               NewtailElixir.sync(invalid_params, :products, valid_opts)
    end

    test "returns {:ok, _string_message} on successful request", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/product/bulk/products",
                                       _body,
                                       _headers ->
        {:ok, %HTTPoison.Response{status_code: 202}}
      end)

      assert {:ok, "Products have been enqueued for sync"} ==
               NewtailElixir.sync(valid_params, :products, valid_opts)
    end

    test "returns {:error, _map} when request fails", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/product/bulk/products",
                                       _body,
                                       _headers ->
        {:error, %HTTPoison.Error{reason: "Network error"}}
      end)

      assert {:error,
              %{
                reason: "Network error",
                fingerprint: "https://api.newtail.com/product/bulk/products",
                metadata: %{url: "https://api.newtail.com/product/bulk/products"}
              }} == NewtailElixir.sync(valid_params, :products, valid_opts)
    end

    test "returns {:unexpected_response, _map} when response is not 202 or 422", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/product/bulk/products",
                                       _body,
                                       _headers ->
        {:ok, %HTTPoison.Response{status_code: 301, body: "Moved Permanently"}}
      end)

      assert {:unexpected_response, %{status_code: 301, body: "Moved Permanently"}} ==
               NewtailElixir.sync(valid_params, :products, valid_opts)
    end
  end

  describe "sync/3 when synching inventories" do
    setup do
      valid_opts = [
        app_id: "test_app_id",
        api_key: "test_api_key"
      ]

      valid_params = [
        %{
          product_sku: "product_sku",
          price: 25.00,
          promotional_price: 20.00,
          is_available: true
        }
      ]

      %{valid_opts: valid_opts, valid_params: valid_params}
    end

    test "returns {:error, changeset errors} on changeset validation errors", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      invalid_params = valid_params ++ [%{product_sku: "product_sku2"}]

      assert {:error,
              "The following params are invalid: [[\"is_available: can't be blank\", \"price: can't be blank\", \"promotional_price: can't be blank\"]]"} ==
               NewtailElixir.sync(invalid_params, :inventories, valid_opts)
    end

    test "returns {:ok, _string_message} on successful request", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/product/bulk/inventories",
                                       _body,
                                       _headers ->
        {:ok, %HTTPoison.Response{status_code: 202}}
      end)

      assert {:ok, "Products have been enqueued for sync"} ==
               NewtailElixir.sync(valid_params, :inventories, valid_opts)
    end

    test "returns {:error, _map} when request fails", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/product/bulk/inventories",
                                       _body,
                                       _headers ->
        {:error, %HTTPoison.Error{reason: "Network error"}}
      end)

      assert {:error,
              %{
                reason: "Network error",
                fingerprint: "https://api.newtail.com/product/bulk/inventories",
                metadata: %{url: "https://api.newtail.com/product/bulk/inventories"}
              }} == NewtailElixir.sync(valid_params, :inventories, valid_opts)
    end

    test "returns {:unexpected_response, _map} when response is not 202 or 422", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/product/bulk/inventories",
                                       _body,
                                       _headers ->
        {:ok, %HTTPoison.Response{status_code: 301, body: "Moved Permanently"}}
      end)

      assert {:unexpected_response, %{status_code: 301, body: "Moved Permanently"}} ==
               NewtailElixir.sync(valid_params, :inventories, valid_opts)
    end
  end
end
