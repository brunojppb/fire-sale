defmodule FireSale.Worker.ObanJob do
  @moduledoc """
  Oban jobs inserted into Postgres for performing various background tasks.
  This is a very simplified mapping to the PG table so I can have a dead-simple
  UI on my admin panel and see which jobs failed/successed.
  """
  use Ecto.Schema

  @type t :: %__MODULE__{
          state: String.t(),
          queue: String.t(),
          args: map(),
          errors: list(map()),
          inserted_at: NaiveDateTime.t()
        }

  schema "oban_jobs" do
    field :state, Ecto.Enum,
      # See: https://github.com/sorentwo/oban/blob/d2c19b4a533a9309e28fe84b5f220fe29f5defec/lib/oban/migrations/postgres/v01.ex#L18-L23
      values: [:available, :scheduled, :executing, :retryable, :completed, :discarded]

    field :queue, :string
    field :args, :map
    field :errors, {:array, :map}
    field :inserted_at, :utc_datetime
  end
end
