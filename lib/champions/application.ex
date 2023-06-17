defmodule Champions.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ChampionsWeb.Telemetry,
      # Start the Ecto repository
      Champions.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Champions.PubSub},
      # Start Finch
      {Finch, name: Champions.Finch},
      # Start the Endpoint (http/https)
      ChampionsWeb.Endpoint
      # Start a worker by calling: Champions.Worker.start_link(arg)
      # {Champions.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Champions.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChampionsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
