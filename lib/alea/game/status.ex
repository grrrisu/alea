defmodule Alea.Status do
  @moduledoc """
  Represents the ownership and wishlist status of a game.
  """

  defstruct [
    :own,
    :prevowned,
    :fortrade,
    :want,
    :wanttoplay,
    :wanttobuy,
    :wishlist,
    :preordered,
    :lastmodified
  ]
end
