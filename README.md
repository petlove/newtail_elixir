<h1 align="center">
  <br>
  NewtailElixir
  <br>
</h1>

## About

NewtailElixir simplifies the integration with the Newtail Retail Media APIs, currently supporting the synchronization of products and inventories.

## Installation

### 1. **Add the Dependency**
Include the library in your mix.exs file under the deps function. This ensures the library is fetched from the specified GitHub repository.

```elixir
def deps do
  [
    {:newtail_elixir, github: "petlove/newtail_elixir"}
  ]
end
```

Run `mix deps.get` in your terminal to fetch the dependency.

### 2. **Configure the Base URL**
Set the `base_url` configuration in your application. This is required for the library to communicate with the Newtail Retail Media APIs. The values for `app_id` and `api_key` are required to be sent over in the `opts` when calling the library (see Usage for more information), but setting their values in environment variables and definind them here alongside the base url is a good practice:

```elixir
config :newtail_elixir,
  app_id: System.fetch_env!("NEWTAIL_APP_ID"),
  api_key: System.fetch_env!("NEWTAIL_API_KEY"),
  base_url: System.fetch_env!("NEWTAIL_BASE_URL")
```

## Usage

```elixir
NewtailElixir.sync(params, type, opts)
```

The `type` argument is an atom that has to be either `:products` or `:inventories`.

The `params` argument will vary depending on the type. All accepted (required/optional) fields can be found [here](https://newtail-media.readme.io/reference/sincronizacao-de-catalogo-por-api) for products and [here](https://newtail-media.readme.io/reference/sincroniza%C3%A7%C3%A3o-de-invent%C3%A1rio) for inventories.

The `opts` argument is a list that must contain both `api_key` and `app_id`.
