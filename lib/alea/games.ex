defmodule Alea.Games do
  @moduledoc """
  Context module for managing games
  """

  alias Alea.Game

  @doc """
  Fetches games from BoardGameGeek and parses them into Game structs.
  """
  def fetch_bgg_games do
    case bgg_client().fetch_games() do
      {:ok, xml} ->
        parse_games(xml)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def parse_games(xml) do
    try do
      {:ok, Game.parse(xml)}
    catch
      :exit, {:fatal, reason} ->
        {:error, "Invalid XML: #{inspect(reason)}"}
    end
  end

  defp bgg_client do
    Application.get_env(:alea, :bgg_client, Alea.BggClient)
  end
end
