defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation, task_prefix \\ nil) do
    Multi.new()
    |> Multi.run(task_name(task_prefix, :get_account), fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(task_name(task_prefix, :update_balance), fn repo, changes ->
      account = Map.get(changes, task_name(task_prefix, :get_account))
      update_balance(repo, account, value, operation)
    end)
    |> Multi.run(task_name(task_prefix, :account), fn repo, changes ->
      account = Map.get(changes, task_name(task_prefix, :update_balance))
      preload_user(repo, account)
    end)
  end

  defp task_name(nil, task), do: task
  defp task_name(task_prefix, task) do
    "#{Atom.to_string(task_prefix)}_#{Atom.to_string(task)}"
    |> String.to_atom()
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found!"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> operation(value, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error
  defp update_account(value, repo, account) do
    account
    |> Account.changeset(%{balance: value})
    |> repo.update()
  end

  defp preload_user(repo, account) do
    {:ok, repo.preload(account, :user)}
  end
end
