defmodule Alea.GameTest do
  use ExUnit.Case, async: true

  alias Alea.Game

  @xml """
  <?xml version="1.0" encoding="utf-8" standalone="yes"?>
  <items totalitems="2" termsofuse="https://boardgamegeek.com/xmlapi/termsofuse" pubdate="Mon, 29 Sep 2025 06:43:23 +0000">
  <item objecttype="thing" objectid="173346" subtype="boardgame" collid="103641571">
     <name sortindex="1">7 Wonders Duel</name>
    <yearpublished>2015</yearpublished>
      <image>https://cf.geekdo-images.com/zdagMskTF7wJBPjX74XsRw__original/img/Ju836WNSaW7Mab9Vjq2TJ_FqhWQ=/0x0/filters:format(jpeg)/pic2576399.jpg</image>
    <thumbnail>https://cf.geekdo-images.com/zdagMskTF7wJBPjX74XsRw__small/img/gV1-ckZSIC-dCxxpq1Y7GmPITzQ=/fit-in/200x150/filters:strip_icc()/pic2576399.jpg</thumbnail>
  	<status own="1" prevowned="0" fortrade="0" want="0" wanttoplay="0" wanttobuy="0" wishlist="0"  preordered="0" lastmodified="2023-02-17 13:25:03" />
     <numplays>8</numplays>
    </item>
  <item objecttype="thing" objectid="267813" subtype="boardgame" collid="103641571">
     <name sortindex="1">Aeon&#039;s End</name>
    <yearpublished>2016</yearpublished>
      <image>https://cf.geekdo-images.com/d50LceHj6LIafa4S_qIsCg__original/img/4MsKNGm47PU9BGW4i2yamMlRSQ0=/0x0/filters:format(jpeg)/pic3189350.jpg</image>
    <thumbnail>https://cf.geekdo-images.com/d50LceHj6LIafa4S_qIsCg__small/img/KMFA-gXm_LbZpyXSAHbIZm-eAcQ=/fit-in/200x150/filters:strip_icc()/pic3189350.jpg</thumbnail>
  	<status own="0" prevowned="0" fortrade="0" want="0" wanttoplay="1" wanttobuy="0" wishlist="0"  preordered="0" lastmodified="2023-09-21 09:42:58" />
     <numplays>0</numplays>
    </item>
  </items>
  """

  test "parses XML and returns list of Game structs" do
    [game | _] = Game.parse(@xml)

    assert game.objectid == "173346"
    assert game.name == "7 Wonders Duel"
    assert game.sortindex == 1
    assert game.yearpublished == 2015
    assert game.numplays == 8

    assert game.image ==
             "https://cf.geekdo-images.com/zdagMskTF7wJBPjX74XsRw__original/img/Ju836WNSaW7Mab9Vjq2TJ_FqhWQ=/0x0/filters:format(jpeg)/pic2576399.jpg"

    assert game.thumbnail ==
             "https://cf.geekdo-images.com/zdagMskTF7wJBPjX74XsRw__small/img/gV1-ckZSIC-dCxxpq1Y7GmPITzQ=/fit-in/200x150/filters:strip_icc()/pic2576399.jpg"
  end

  test "converts status strings to booleans" do
    [game | _] = Game.parse(@xml)

    assert game.status.own == true
    assert game.status.prevowned == false
    assert game.status.wishlist == false
    assert game.status.lastmodified == "2023-02-17 13:25:03"
  end

  test "returns empty list for XML with no games" do
    xml = """
    <?xml version="1.0" encoding="utf-8"?>
    <items totalitems="0"></items>
    """

    assert Game.parse(xml) == []
  end
end
