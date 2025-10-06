defmodule AleaWeb.GamesLiveTest do
  use AleaWeb.ConnCase

  import Phoenix.LiveViewTest

  import Mox

  setup :verify_on_exit!

  @xml """
  <?xml version="1.0" encoding="utf-8"?>
  <items totalitems="1">
    <item objecttype="thing" objectid="240980" subtype="boardgame" collid="114930264">
      <name sortindex="1">Blood on the Clocktower</name>
      <yearpublished>2022</yearpublished>
      <image>https://cf.geekdo-images.com/HINb2nkFn5IiZxAlzQIs4g__original/img/e7izEwSmnBPiErsIF6hlWbgybBE=/0x0/filters:format(jpeg)/pic7009391.jpg</image>
      <thumbnail>https://cf.geekdo-images.com/HINb2nkFn5IiZxAlzQIs4g__small/img/cRCX-PIROiSFG5aLvwkn2O7tHsg=/fit-in/200x150/filters:strip_icc()/pic7009391.jpg</thumbnail>
      <status own="0" prevowned="0" fortrade="0" want="0" wanttoplay="1" wanttobuy="0" wishlist="1" wishlistpriority="3" preordered="0" lastmodified="2024-12-26 03:51:37"/>
      <numplays>3</numplays>
    </item>
  </items>
  """

  test "render all games", %{conn: conn} do
    expect(Alea.BggClientMock, :fetch_games, 2, fn ->
      {:ok, @xml}
    end)

    {:ok, view, _html} = live(conn, "/games")
    assert view |> has_element?("h1", "Games")
    assert view |> has_element?("h3", "Blood on the Clocktower")
  end
end
