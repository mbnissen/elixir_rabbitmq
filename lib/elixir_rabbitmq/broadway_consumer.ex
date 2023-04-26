defmodule ElixitRabbitmq.BroadwayConsumer do
  use Broadway

  alias ElixitRabbitmq.BroadwayConsumer
  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: BroadwayConsumer,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "gen_server_test_queue",
           connection: [
             username: "guest",
             password: "guest"
           ],
           qos: [
             prefetch_count: 50
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 1500,
          concurrency: 5
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(fn data -> {data, "hest"} end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)
    IO.inspect(list, label: "Got batch")
    messages
  end
end
