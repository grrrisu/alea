defmodule Alea.Repo do
  use Ecto.Repo,
    otp_app: :alea,
    adapter: Ecto.Adapters.Postgres
end
