defmodule GenserverExplainedSimply.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GenserverExplainedSimplyWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:genserver_explained_simply, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GenserverExplainedSimply.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GenserverExplainedSimply.Finch},
      {GenserverExplainedSimply.Counter, []},
      # Start a worker by calling: GenserverExplainedSimply.Worker.start_link(arg)
      # {GenserverExplainedSimply.Worker, arg},
      # Start to serve requests, typically the last entry
      GenserverExplainedSimplyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenserverExplainedSimply.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GenserverExplainedSimplyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
