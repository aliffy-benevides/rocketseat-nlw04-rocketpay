defmodule Rocketpay.Accounts.Transfer do
  alias Ecto.Multi
  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Accounts.Transfers.Response, as: TransferResponse

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw, :from) end)
    |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit, :to) end)
    |> run_transaction()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{from_account: from_account, to_account: to_account}} -> {:ok, TransferResponse.build(from_account, to_account)}
    end
  end
end
