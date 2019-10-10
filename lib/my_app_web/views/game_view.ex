defmodule MyAppWeb.GameView do
  use MyAppWeb, :view

  def render("index.json", %{games: games}) do
    render_many(games, MyAppWeb.GameView, "game.json")
  end

  def render("game.json", %{game: game}) do
    %{
      id: game.id,
      league: game.league,
      season: game.season,
      date: game.date,
      homeTeam: game.home_team,
      awayTeam: game.away_team,
      fthg: game.fthg,
      ftag: game.ftag
    }
  end
end
