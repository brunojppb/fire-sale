defmodule FireSale.Worker.ObanJob do
  @moduledoc """
  Oban jobs inserted into the DB
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
      values: [:available, :scheduled, :executing, :retryable, :completed, :discarded]

    field :queue, :string
    field :args, :map
    field :errors, {:array, :map}
    field :inserted_at, :utc_datetime
  end
end
