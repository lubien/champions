defmodule Champions.Repo do
  use Ecto.Repo,
    otp_app: :champions,
    adapter: Ecto.Adapters.Postgres
end
