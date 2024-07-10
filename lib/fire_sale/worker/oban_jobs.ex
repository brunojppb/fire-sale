defmodule FireSale.Worker.ObanJobs do
  @moduledoc """
  Listing of Oban jobs
  """
  import Ecto.Query, warn: false
  alias FireSale.Worker.ObanJob
  alias FireSale.Repo

  def all() do
    query = from j in ObanJob, order_by: fragment("? DESC", j.inserted_at)
    Repo.all(query)
  end
end
