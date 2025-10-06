defmodule Alea.Game do
  @moduledoc """
  Represents a board game from BoardGameGeek.
  """

  import SweetXml

  alias Alea.{Game, Status}

  defstruct [
    :objectid,
    :objecttype,
    :subtype,
    :collid,
    :name,
    :sortindex,
    :yearpublished,
    :image,
    :thumbnail,
    :numplays,
    :status
  ]

  def parse(xml) do
    xml
    |> parse_xml()
    |> Enum.map(fn game ->
      status = struct(Status, convert_status(game.status))
      struct(Game, %{game | status: status})
    end)
  end

  defp parse_xml(xml) do
    xml
    |> xpath(~x"//item"l,
      objectid: ~x"./@objectid"s,
      objecttype: ~x"./@objecttype"s,
      subtype: ~x"./@subtype"s,
      collid: ~x"./@collid"s,
      name: ~x"./name/text()"s,
      sortindex: ~x"./name/@sortindex"i,
      yearpublished: ~x"./yearpublished/text()"i,
      image: ~x"./image/text()"s,
      thumbnail: ~x"./thumbnail/text()"s,
      numplays: ~x"./numplays/text()"i,
      status: [
        ~x"./status",
        own: ~x"./@own"s,
        prevowned: ~x"./@prevowned"s,
        fortrade: ~x"./@fortrade"s,
        want: ~x"./@want"s,
        wanttoplay: ~x"./@wanttoplay"s,
        wanttobuy: ~x"./@wanttobuy"s,
        wishlist: ~x"./@wishlist"s,
        preordered: ~x"./@preordered"s,
        lastmodified: ~x"./@lastmodified"s
      ]
    )
  end

  # Convert "0"/"1" strings to booleans
  defp convert_status(status) do
    %{
      own: to_boolean(status.own),
      prevowned: to_boolean(status.prevowned),
      fortrade: to_boolean(status.fortrade),
      want: to_boolean(status.want),
      wanttoplay: to_boolean(status.wanttoplay),
      wanttobuy: to_boolean(status.wanttobuy),
      wishlist: to_boolean(status.wishlist),
      preordered: to_boolean(status.preordered),
      lastmodified: status.lastmodified
    }
  end

  defp to_boolean("1"), do: true
  defp to_boolean("0"), do: false
  defp to_boolean(_), do: false
end
