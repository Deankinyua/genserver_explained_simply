defmodule GenserverExplainedSimplyWeb.CounterLive do
  use GenserverExplainedSimplyWeb, :live_view

  alias GenserverExplainedSimply.Counter

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-6">
      <.flash_group flash={@flash} />
      <h1 class="text-2xl font-semibold text-zinc-900">Counter</h1>
      <p class="text-4xl font-bold text-zinc-700" id="counter-value">{@count}</p>
      <div class="flex gap-4">
        <button
          phx-click="increment"
          type="button"
          class="rounded-lg bg-zinc-900 px-4 py-2 text-sm font-semibold text-white hover:bg-zinc-700"
          aria-label="Increment"
        >
          +
        </button>
        <button
          phx-click="decrement"
          type="button"
          class="rounded-lg bg-zinc-900 px-4 py-2 text-sm font-semibold text-white hover:bg-zinc-700"
          aria-label="Decrement"
        >
          −
        </button>

        <button
          phx-click="long_running_work"
          type="button"
          class="rounded-lg bg-zinc-900 px-4 py-2 text-sm font-semibold text-white hover:bg-zinc-700"
          aria-label="Decrement"
        >
          Do some long running work
        </button>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    count = Counter.get_current_value()

    {:ok, assign(socket, :count, count)}
  end

  @impl Phoenix.LiveView
  def handle_event("increment", _params, socket) do
    count = Counter.increment()

    {:noreply, assign(socket, :count, count)}
  end

  def handle_event("decrement", _params, socket) do
    case Counter.decrement() do
      {:ok, count} ->
        {:noreply, assign(socket, :count, count)}

      {:error, :already_zero} ->
        {:noreply,
         socket
         |> assign(:count, 0)
         |> put_flash(:error, "Counter is already at zero and cannot go lower.")}
    end
  end

  def handle_event("long_running_work", _params, socket) do
    Counter.do_complex_calculation(self())
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:complex_work_completed, socket) do
    {:noreply, put_flash(socket, :info, "Long running work complete. Hurray!!")}
  end
end
