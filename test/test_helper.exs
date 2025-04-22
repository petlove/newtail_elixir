Mox.defmock(HttpClientMock, for: NewtailElixir.HttpClientBehaviour)
Application.put_env(:newtail_elixir, :http_client, HttpClientMock)
Application.put_env(:newtail_elixir, :base_url, "https://api.newtail.com")

ExUnit.start()
