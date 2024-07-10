defmodule FireSale.Worker.ObanJobs do
  @moduledoc """
  Listing of Oban jobs
  """
  import Ecto.Query, warn: false
  alias FireSale.Worker.ObanJob
  alias FireSale.Repo

  def all() do
    Repo.all(ObanJob)
  end
end
