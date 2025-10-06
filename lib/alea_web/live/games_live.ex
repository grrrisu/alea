defmodule AleaWeb.GamesLive do
  use AleaWeb, :live_view

  alias Alea.Games

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(games: get_games())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.main_title>Games</.main_title>
      <.box_grid cols="4">
        <:box :for={game <- @games}>
          <div class="p-4 border rounded flex flex-col" style="height: 500px">
            <div class="basis-1/8">
              <.sub_title class="text-lg font-bold">{game.name}</.sub_title>
            </div>
            <div class="basis-5/8 overflow-hidden">
              <img src={game.image} alt={game.name} class="w-full" />
            </div>
            <div class="basis-2/8">
              <.info_card value={game.yearpublished} icon="la-birthday-cake" />
            </div>
          </div>
        </:box>
      </.box_grid>
    </Layouts.app>
    """
  end

  defp get_games do
    {:ok, games} = Games.fetch_bgg_games()
    games
  end
end
