defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation, prefix \\ nil) do
    Multi.new()
    |> Multi.run(proccess_name(prefix, :get_account), fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(proccess_name(prefix, :update_balance), fn repo, changes ->
      account = Map.get(changes, proccess_name(prefix, :get_account))
      update_balance(repo, account, value, operation)
    end)
    |> Multi.run(proccess_name(prefix, :account), fn repo, changes ->
      account = Map.get(changes, proccess_name(prefix, :update_balance))
      preload_user(repo, account)
    end)
  end

  defp proccess_name(nil, proccess), do: proccess
  defp proccess_name(prefix, proccess) do
    "#{Atom.to_string(prefix)}_#{Atom.to_string(proccess)}"
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
