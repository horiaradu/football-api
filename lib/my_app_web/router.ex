defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json", "proto"]
  end

  scope "/api", MyAppWeb do
    pipe_through :api

    get "/games", GameController, :index
    get "/games-proto", GameController, :index_proto
  end

  forward "/check", HealthCheckup

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "My App"
      }
    }
  end
end
