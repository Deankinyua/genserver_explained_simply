defmodule GenserverExplainedSimply.Counter do
  @moduledoc """
  A GenServer that holds a counter value. Supports increment and decrement operations
  """

  use GenServer

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @spec get_current_value :: :integer
  def get_current_value do
    GenServer.call(__MODULE__, :get_counter)
  end

  @spec increment :: :integer
  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  @spec decrement :: {:ok, :integer} | {:error, :already_zero}
  def decrement do
    GenServer.call(__MODULE__, :decrement)
  end

  @spec do_complex_calculation(pid()) :: :ok
  def do_complex_calculation(pid) do
    # This will potentially take a long time
    GenServer.cast(__MODULE__, {:very_complex_calc, pid})
  end

  @impl GenServer
  def handle_call(:get_counter, _from, state), do: {:reply, state, state}

  def handle_call(:increment, _from, state) do
    new_state = state + 1
    {:reply, new_state, new_state}
  end

  def handle_call(:decrement, _from, 0) do
    {:reply, {:error, :already_zero}, 0}
  end

  def handle_call(:decrement, _from, state) when state > 0 do
    new_state = state - 1
    {:reply, {:ok, new_state}, new_state}
  end

  @impl GenServer
  def handle_cast({:very_complex_calc, pid}, state) do
    Process.send_after(pid, :complex_work_completed, 10000)
    {:noreply, state}
  end
end
