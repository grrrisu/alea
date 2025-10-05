defmodule Alea.BggClientBehaviour do
  @moduledoc """
  Behaviour for BoardGameGeek client
  """
  @callback fetch_games() :: {:ok, String.t()} | {:error, String.t()}
end
