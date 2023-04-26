defmodule ElixirRabbitmq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElixirRabbitmqWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirRabbitmq.PubSub},
      # Start Finch
      {Finch, name: ElixirRabbitmq.Finch},
      # Start the Endpoint (http/https)
      ElixirRabbitmqWeb.Endpoint,
      # ElixirRabbitmq.Consumer,
      ElixitRabbitmq.BroadwayConsumer
      # Start a worker by calling: ElixirRabbitmq.Worker.start_link(arg)
      # {ElixirRabbitmq.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirRabbitmq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirRabbitmqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
