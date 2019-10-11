defmodule MyAppWeb.Games do
  use Protobuf, """
    message Game {
      required string id = 1;
      required string league = 2;
      required string season = 3;
    }
  """

  def safe_decode(bytes) do
    try do
      {:ok, MyAppWeb.Games.Game.decode(bytes)}
    rescue
      ErlangError ->
        {:error, "Error encoding data"}
    end
  end
end
