defmodule FireSaleWeb.JobsLive do
  alias FireSale.Worker.ObanJobs
  use FireSaleWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold">Background Jobs</h1>
    <div class="flex flex-col mt-4 gap-2">
      <%= for job <- @jobs do %>
        <div class="bg-zinc-200 dark:bg-gray-800 flex flex-col gap-2">
          <div>
            Inserted at <%= Calendar.strftime(job.inserted_at, "%y.%m.%d %I:%M:%S %p") %>
            <.badge value={to_string(job.state)} kind={job.state} />
          </div>
          <div>
            <h3 class="text-sm font-bold">Args</h3>
            <div class="bg-zinc-300 dark:bg-gray-700 p-2 my-2">
              <%= job.args %>
            </div>
          </div>
          <div>
            <%= if not Enum.empty?(job.errors) do %>
              <h3 class="text-sm font-bold">Errors</h3>
              <%= for error <- job.errors do %>
                <details>
                  <summary>Click to expand</summary>
                  <pre class="bg-zinc-300 dark:bg-gray-700 p-2 overflow-auto">
                  <%= error %>
                </pre>
                </details>
              <% end %>
            <% end %>
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
