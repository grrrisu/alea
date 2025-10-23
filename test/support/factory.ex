defmodule Alea.Factory do
  @moduledoc """
  object factory for game
  """
  alias Alea.{Game, Status}

  @game_defaults %{
    objectid: 123,
    objecttype: "thing",
    subtype: "boardgame",
    collid: 124,
    name: "7 Wonders Duel",
    sortindex: "1",
    yearpublished: 2015,
    image:
      "https://cf.geekdo-images.com/zdagMskTF7wJBPjX74XsRw__original/img/Ju836WNSaW7Mab9Vjq2TJ_FqhWQ=/0x0/filters:format(jpeg)/pic2576399.jpg",
    thumbnail:
      "https://cf.geekdo-images.com/zdagMskTF7wJBPjX74XsRw__small/img/gV1-ckZSIC-dCxxpq1Y7GmPITzQ=/fit-in/200x150/filters:strip_icc()/pic2576399.jpg",
    numplays: 3,
    status: %Status{}
  }

  def build(:game, opts \\ %{}) do
    %Game{} |> Map.merge(@game_defaults) |> Map.merge(opts)
  end
end
