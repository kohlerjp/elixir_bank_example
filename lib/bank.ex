defmodule Bank do
  use Application

  def start(_type, _args) do
    Bank.Supervisor.start_link(name: Bank.Supervisor)
  end
end
