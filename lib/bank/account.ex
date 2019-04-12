defmodule Bank.Account do
  use GenServer

  @moduledoc """
  Documentation for Bank.
  """

  ## Client API
  def start_link(options) do
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def balance(name) do
    GenServer.call(__MODULE__, {:balance, name})
  end

  def open_account(name) do
    GenServer.call(__MODULE__, {:open, name})
  end

  def deposit(account, amount) do
    GenServer.cast(__MODULE__, {:deposit, account, amount})
  end

  def withdraw(account, amount) do
    GenServer.call(__MODULE__, {:withdraw, account, amount})
  end

  def loan() do
    raise "Nope"
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}} # stateful value
  end

  def handle_call({:open, name}, _from, current_state) do
    if Map.has_key?(current_state, name) do
      {:reply, {:error, "Account exists"}, current_state}
    else
      {:reply, {:ok, "Account #{name} created"}, Map.put(current_state, name, 0)}
    end
  end
  def handle_call({:balance, name}, _from, current_state) do
    if Map.has_key?(current_state, name) do
      {:reply, {:ok, "$#{Map.get(current_state, name)}"}, current_state}
    else
      {:reply, {:error, "No Account"}, current_state}
    end
  end
  def handle_call({:withdraw, account, amount}, _from, current_state) do
    if Map.has_key?(current_state, account) do
      existing_balance = Map.get(current_state, account)
      new_balance = existing_balance - amount
      {:reply, {:ok, new_balance}, Map.put(current_state, account, new_balance)}
    else
      {:reply, {:error, "No Account"}, current_state}
    end
  end

  def handle_cast({:deposit, account, amount}, current_state) do
    current_balance = Map.get(current_state, account)
    {:noreply, Map.put(current_state, account, current_balance + amount)}
  end
end
