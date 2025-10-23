defmodule Alea.GamesTest do
  use ExUnit.Case, async: true

  import Mox

  setup :verify_on_exit!

  alias Alea.{Games, Status}
  alias Alea.Factory

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

  describe "fetch games from BGG" do
    test "returns {:ok, games} on success" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:ok, @xml}
      end)

      assert {:ok, games} = Games.fetch_bgg_games()
      assert length(games) == 1
      assert hd(games).name == "Blood on the Clocktower"
    end

    test "returns {:error, reason} with invalid XML" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:ok, "not xml"}
      end)

      assert {:error, "Invalid XML" <> _} = Games.fetch_bgg_games()
    end

    test "returns {:error, reason} on API failure" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:error, "Network error"}
      end)

      assert {:error, "Network error"} = Games.fetch_bgg_games()
    end
  end

  describe "filter" do
    @games [
             %{own: true},
             %{own: true, wanttoplay: true},
             %{own: false, wishlist: true},
             %{own: false, prevowned: true}
           ]
           |> Enum.with_index()
           |> Enum.map(fn {opts, n} ->
             Factory.build(
               :game,
               %{objectid: 1 + n, status: Map.merge(%Status{}, opts)}
             )
           end)

    test "empty" do
      games = Games.filter(@games, %{})
      assert Enum.count(games) == 4
    end

    test "nothing selected" do
      games = Games.filter(@games, %{"own" => false})
      assert Enum.count(games) == 4
    end

    # test "extensions" do
    #   games = Games.filter(@games, %{"extensions" => true})
    #   assert Enum.count(games) == 0
    # end

    test "own" do
      games = Games.filter(@games, %{"own" => true})
      assert Enum.map(games, & &1.objectid) == [1, 2]
    end

    test "whishlist" do
      games = Games.filter(@games, %{"wishlist" => true})
      assert Enum.map(games, & &1.objectid) == [3]
    end

    test "combined own and whishlist" do
      games = Games.filter(@games, %{"own" => true, "wishlist" => true})
      assert Enum.empty?(games)
    end
  end
end
