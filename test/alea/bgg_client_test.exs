defmodule Alea.BggClientTest do
  use ExUnit.Case, async: true

  import Mox

  # Verify mocks are called
  setup :verify_on_exit!

  @games_xml """
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

  describe "fetch_games" do
    test "returns {:ok, body} on 200 success" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:ok, @games_xml}
      end)

      client = Application.get_env(:alea, :bgg_client)
      {:ok, body} = client.fetch_games()

      assert is_binary(body)
      assert String.contains?(body, "<items")
      assert String.contains?(body, "7 Wonders Duel")
      assert String.contains?(body, "Aeon&#039;s End")
    end

    test "returns error on API failure" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:error, "BGG API returned status 500: Internal Server Error"}
      end)

      client = Application.get_env(:alea, :bgg_client)
      assert {:error, error_msg} = client.fetch_games()
      assert error_msg =~ "500"
    end

    test "returns error on network failure" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:error, "Network error: :econnrefused"}
      end)

      client = Application.get_env(:alea, :bgg_client)
      assert {:error, error_msg} = client.fetch_games()
      assert error_msg =~ "Network error"
    end

    test "returns error when max retries exceeded" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:error, "Max retries (5) exceeded while fetching games from BGG"}
      end)

      client = Application.get_env(:alea, :bgg_client)
      assert {:error, error_msg} = client.fetch_games()
      assert error_msg =~ "Max retries"
    end

    test "handles 404 not found" do
      expect(Alea.BggClientMock, :fetch_games, fn ->
        {:error, "BGG API returned status 404: Not Found"}
      end)

      client = Application.get_env(:alea, :bgg_client)
      assert {:error, error_msg} = client.fetch_games()
      assert error_msg =~ "404"
    end
  end
end
