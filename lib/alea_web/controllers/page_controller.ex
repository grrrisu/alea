defmodule AleaWeb.PageController do
  use AleaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
