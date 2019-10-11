defmodule MyAppWeb.GamesService do
  @all_games File.read!("data/Data.csv")
             |> String.split("\n")
             |> Enum.map(&String.split(&1, ","))
             |> Enum.filter(fn
               [_, "Div" | _] ->
                 false

               [""] ->
                 false

               _ ->
                 true
             end)

  def games(qLeague, qSeason) do
    data =
      @all_games
      |> Enum.filter(fn
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
  end
end
