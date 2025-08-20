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

      assert {:ok, "Inventories have been enqueued for sync"} ==
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

  describe "query_ads/2" do
    setup do
      valid_opts = [
        app_id: "test_app_id",
        api_key: "test_api_key",
        publisher_id: "12345"
      ]

      valid_params = %{
        context: "search",
        term: "ração true",
        user_id: "6a746448-cf59-42bc-aa3d-a426844ad115",
        session_id: "f361661f-5986-4779-9009-a34562f18347",
        channel: "msite",
        placements: %{
          search: %{quantity: 2, types: ["product"]}
        }
      }

      %{valid_opts: valid_opts, valid_params: valid_params}
    end

    test "returns {:ok, body} on successful request", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      response_body = %{
        "query_at" => "2025-08-11T15:43:11.306008328+00:00",
        "query_id" => "f129c962-ad50-4ac1-8af4-2e8c82aa55f1",
        "request_id" => "9c6ff349-0a08-4a72-98e7-e1c93612976c",
        "search" => [
          %{
            "ad_id" => "2f76052b-1b05-4b87-a5d6-776d61f479fb",
            "campaign_name" => "Teste true",
            "click_url" => "click URL",
            "destination_url" =>
              "https://www.petlove.com.br/racao-seca-true-para-caes-adultos-racas-pequenas/p?sku=2638253",
            "impression_url" => "impression URL",
            "position" => 1,
            "product_metadata" => nil,
            "product_name" => "Ração Seca True para Cães Adultos Raças Pequenas",
            "product_sku" => "2638253",
            "seller_id" => nil,
            "type" => "product",
            "view_url" => "view URL"
          }
        ]
      }

      expect(HttpClientMock, :post, fn "https://api.newtail.com/v1/rma/12345", _body, _headers ->
        {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(response_body)}}
      end)

      assert {:ok, response_body} ==
               NewtailElixir.query_ads(valid_params, valid_opts)
    end

    test "returns {:error, message} on changeset validation errors", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      invalid_params = Map.put(valid_params, :placements, %{search: %{quantity: 0}})

      assert {:error, "The following params are invalid: [[\"placements: invalid placements\"]]"} ==
               NewtailElixir.query_ads(invalid_params, valid_opts)
    end

    test "returns {:error, map} when request fails", %{
      valid_opts: valid_opts,
      valid_params: valid_params
    } do
      expect(HttpClientMock, :post, fn "https://api.newtail.com/v1/rma/12345", _body, _headers ->
        {:error, %HTTPoison.Error{reason: "Network error"}}
      end)

      assert {:error,
              %{
                reason: "Network error",
                fingerprint: "https://api.newtail.com/v1/rma/12345",
                metadata: %{url: "https://api.newtail.com/v1/rma/12345"}
              }} == NewtailElixir.query_ads(valid_params, valid_opts)
    end
  end
end
