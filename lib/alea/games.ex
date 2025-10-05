# lib/alea/games.ex
defmodule Alea.Games do
  @moduledoc """
  Contecxt module for managing games
  """

  @doc """
  Fetches games from BoardGameGeek
  """
  def fetch_bgg_games do
    bgg_client().fetch_games()
  end

  defp bgg_client do
    Application.get_env(:alea, :bgg_client, Alea.BggClient)
  end
end
