defmodule AleaWeb.GamesLive do
  use AleaWeb, :live_view

  alias Alea.Games

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "Games", games: get_games())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.main_title>Games</.main_title>
      <.box_grid cols="4">
        <:box :for={game <- @games}>
          <div
            class="border border-info rounded flex flex-col bg-linear-to-br from-base-300 to-base-300/50"
            style="height: 500px"
          >
            <div class="basis-1/4 p-4">
              <.sub_title>{game.name}</.sub_title>
            </div>
            <div class="relative basis-1/2 w-full">
              <img
                src={game.image}
                alt={game.name}
                class="absolute inset-0 w-full h-full object-cover"
              />
            </div>
            <div class="basis-1/4 p-4">
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
