defmodule MyAppWeb.GameController do
  use MyAppWeb, :controller
  use PhoenixSwagger

  swagger_path :index do
    get("/api/games")
    summary("List all games")
    description("List all games")

    parameters do
      league(:query, :string, "The league for which to retrieve games")
      season(:query, :string, "The season for which to retrieve games")
    end
    parameter("Accept", :header, :string, "The content type of the response", enum: ["application/json", "application/x-proto"])

    response(200, "Ok", Schema.ref(:Games))
  end

  def index(conn, params) do
    qLeague =
      Map.get(params, "league")
      |> case do
        nil -> nil
        val -> String.upcase(val)
      end

    qSeason = Map.get(params, "season")

    data = MyAppWeb.GamesService.games(qLeague, qSeason)

    get_req_header(conn, "accept")
    |> IO.inspect()
    |> case do
      ["application/x-proto"] -> render(conn, "index.proto", games: data)
      _ -> render(conn, "index.json", games: data)
    end
  end

  def swagger_definitions do
    %{
      Game:
        swagger_schema do
          title("Game")
          description("A game")

          properties do
            id(:string, "The ID of the game", required: true)
            league(:string, "The name of the league", required: true)
            season(:string, "The season", required: true)
            date(:string, "The date of the game", format: "dd/MM/YYYY", required: true)
            home_team(:string, "The name of the home team", required: true)
            away_team(:string, "The name of the home team", required: true)
            fthg(:string, "The number of goals scored by the home team", required: true)
            ftag(:string, "The number of goals scored by the away team", required: true)
          end

          example(%{
            away_team: "Eibar",
            date: "19/08/2016",
            ftag: "1",
            fthg: "2",
            home_team: "La Coruna",
            id: "1",
            league: "SP1",
            season: "201617"
          })
        end,
      Games:
        swagger_schema do
          title("Games")
          description("All games")
          type(:array)
          items(Schema.ref(:Game))
        end
    }
  end
end
