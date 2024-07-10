defmodule FireSaleWeb.JobsLive do
  alias FireSale.Worker.ObanJobs
  use FireSaleWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold">Background Jobs</h1>
    <div class="flex flex-col mt-4">
      <%= for job <- @jobs do %>
        <div>
          <div>
            <.badge value={to_string(job.state)} kind={job.state} />
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket
    |> assign_jobs()
    |> ok()
  end

  def assign_jobs(socket) do
    jobs = ObanJobs.all()

    dbg(jobs)

    assign(socket, :jobs, jobs)
  end
end
