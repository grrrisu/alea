defmodule Alea.BggClient do
  @moduledoc """
  Client for fetching games from BoardGameGeek.

  ## Configuration

  Set the `BGG_GAMES_URL` environment variable to your BGG collection endpoint:

      export BGG_GAMES_URL="https://boardgamegeek.com/xmlapi2/collection?username=YOUR_USERNAME&stats=1"

      https://boardgamegeek.com/xmlapi2/thing?id=363757

      https://boardgamegeek.com/xmlapi2/user?name=grrrisu

  ## Retry Behavior

  BGG API returns 202 when processing the request. This client will automatically
  retry with a 2 second delay between attempts, up to a maximum of 5 retries.
  """

  @behaviour Alea.BggClientBehaviour

  @max_retries 5
  @retry_delay_ms 2_000

  @impl true
  def fetch_games() do
    url = System.get_env("BGG_GAMES_URL") || raise "BGG_GAMES_URL not set"
    url = url <> "&excludesubtype=boardgameexpansion"
    try_fetch_games(url, 0)
  end

  defp try_fetch_games(_url, retry_count) when retry_count >= @max_retries do
    {:error, "Max retries (#{@max_retries}) exceeded while fetching games from BGG"}
  end

  defp try_fetch_games(url, retry_count) do
    # File.read("test/support/games.xml")

    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: 202}} ->
        Process.sleep(@retry_delay_ms)
        try_fetch_games(url, retry_count + 1)

      {:ok, %{status: 401, body: _body}} ->
        {:error, "BGG API returned 401 Unauthorized."}

      {:ok, %{status: status, body: body}} ->
        {:error, "BGG API returned status #{status}: #{body}"}

      {:error, %Req.TransportError{reason: reason}} ->
        {:error, "Network error: #{inspect(reason)}"}

      {:error, error} ->
        {:error, "Failed to fetch games: #{inspect(error)}"}
    end
  end
end
