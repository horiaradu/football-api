defmodule MyAppWeb.GameController do
  use MyAppWeb, :controller
  use PhoenixSwagger

  swagger_path :index do
    get "/"
    summary "List all games"
    description "List all games"
    response 200, "Ok", Schema.ref(:Games)
  end
  def index(conn, params) do
    qLeague = Map.get(params, "league")
    qSeason = Map.get(params, "season")

    data =
      File.read!("data/Data.csv")
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))
      |> Enum.filter(fn
        [_, "Div" | _] ->
          false

        [""] ->
          false

        [_, league, season | _]
        when qLeague != nil and qSeason != nil and (league != qLeague or season != qSeason) ->
          false

        [_, league | _] when qLeague != nil and qSeason == nil and league != qLeague ->
          false

        [_, _, season | _] when qLeague == nil and qSeason != nil and season != qSeason ->
          false

        _ ->
          true
      end)
      |> Enum.reduce([], fn entry, acc ->
        [id, league, season, date, home_team, away_team, fthg, ftag | _] = entry

        acc ++
          [
            %{
              id: id,
              league: league,
              season: season,
              date: date,
              home_team: home_team,
              away_team: away_team,
              fthg: fthg,
              ftag: ftag
            }
          ]
      end)

    render(conn, "index.json", games: data)
  end

  def swagger_definitions do
    %{
      Game: swagger_schema do
        title "Game"
        description "A game"
        properties do
          id :string, "The ID of the game", required: true
          league :string, "The name of the league", required: true
          season :string, "The season", required: true
          date :string, "The date of the game", format: "dd/MM/YYYY", required: true
          home_team :string, "The name of the home team", required: true
          away_team :string, "The name of the home team", required: true
          fthg :string, "The number of goals scored by the home team", required: true
          ftag :string, "The number of goals scored by the away team", required: true
        end
        example %{
          away_team: "Eibar",
          date: "19/08/2016",
          ftag: "1",
          fthg: "2",
          home_team: "La Coruna",
          id: "1",
          league: "SP1",
          season: "201617"
      }
      end,
      Games: swagger_schema do
        title "Games"
        description "All games"
        type :array
        items Schema.ref(:Game)
      end
    }
  end
end
