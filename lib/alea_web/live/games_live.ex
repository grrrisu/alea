defmodule AleaWeb.GamesLive do
  use AleaWeb, :live_view

  alias Alea.Games

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page_title: "Games",
       filter: %{"extensions" => false, "own" => true}
     )
     |> get_games()}
  end

  # %{"_target" => ["own"], "extensions" => "on"}
  def handle_event("apply_filter", params, socket) do
    socket = socket |> change_filter(params) |> apply_filter()
    {:noreply, socket}
  end

  defp change_filter(socket, %{"_target" => [target]} = params) do
    value = if params[target] == "on", do: true, else: false
    filter = Map.put(socket.assigns.filter, target, value)
    assign(socket, filter: filter)
  end

  def apply_filter(socket) do
    games = Games.filter(socket.assigns.all, socket.assigns.filter)
    assign(socket, games: games)
  end

  def render(assigns) do
    assigns = assign(assigns, :count, Enum.count(assigns.games))

    ~H"""
    <Layouts.app flash={@flash}>
      <.main_title>Games ({@count})</.main_title>

      <.filter filter={@filter}>
        <:option name="extensions" icon="hero-puzzle-piece" />
        <:option name="own" icon="hero-building-library" />
        <:option name="wanttoplay" icon="hero-bookmark" />
        <:option name="wishlist" icon="hero-heart" />
        <:option name="preordered" icon="hero-truck" />
        <:option name="prevowned" icon="hero-arrow-down-on-square" />
        <:option name="fortrade" icon="la-cash-register" />
      </.filter>

      <.box_grid cols="4" class="gap-4">
        <:box :for={game <- @games}>
          <section
            class="border rounded-lg border-info rounded flex flex-col bg-linear-to-br from-base-300 to-base-300/50"
            style="height: 500px"
            id={"game-#{game.objectid}"}
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
          </section>
        </:box>
      </.box_grid>
    </Layouts.app>
    """
  end

  def filter(assigns) do
    assigns = assign(assigns, form: to_form(assigns.filter))

    ~H"""
    <.form for={@form} id="filter-form" phx-change="apply_filter">
      <fieldset class="fieldset bg-base-100 rounded-box w-64 border p-4 flex flex-row">
        <legend class="fieldset-legend">Filter options</legend>
        <label :for={option <- @option} class="label">
          <.filter_input value={@filter[option.name]} name={option.name} />
          <span class={@filter[option.name] && "text-white"}>
            {String.upcase(option.name)}
            <.icon name={option.icon} class="la-2x align-middle" />
          </span>
        </label>
      </fieldset>
    </.form>
    """
  end

  defp filter_input(assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <input type="checkbox" checked={@checked} class="toggle" name={@name} />
    """
  end

  defp get_games(socket) do
    {:ok, games} = Games.fetch_bgg_games()
    socket |> assign(all: games) |> apply_filter()
  end
end
