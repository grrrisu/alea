defmodule Alea.Game do
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
      status = struct(Status, game.status)
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
end
