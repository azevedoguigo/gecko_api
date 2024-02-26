defmodule GeckoApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GeckoApiWeb.Telemetry,
      GeckoApi.Repo,
      {DNSCluster, query: Application.get_env(:gecko_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GeckoApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GeckoApi.Finch},
      # Start a worker by calling: GeckoApi.Worker.start_link(arg)
      # {GeckoApi.Worker, arg},
      # Start to serve requests, typically the last entry
      GeckoApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GeckoApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GeckoApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
