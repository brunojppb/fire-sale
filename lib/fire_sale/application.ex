defmodule FireSale.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FireSaleWeb.Telemetry,
      FireSale.Repo,
      {DNSCluster, query: Application.get_env(:fire_sale, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FireSale.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FireSale.Finch},
      FireSaleWeb.Presence,
      # Start a worker by calling: FireSale.Worker.start_link(arg)
      # {FireSale.Worker, arg},
      # Start to serve requests, typically the last entry
      FireSaleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FireSale.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FireSaleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
