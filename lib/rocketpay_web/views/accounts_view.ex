defmodule RocketpayWeb.AccountsView do
  alias Rocketpay.{Account, User}
  alias Rocketpay.Accounts.Transfers.Response, as: TransferResponse

  def render("update.json", %{account: %Account{
    id: id, balance: balance, user: %User{
      name: name, nickname: nickname, email: email
    }
  }}) do
    %{
      message: "Ballance changed successfully",
      account: %{
        id: id,
        balance: balance,
        user: %{
          name: name, nickname: nickname, email: email
        }
      }
    }
  end

  def render("transfer.json", %{transfer: %TransferResponse{from_account: from_account, to_account: to_account}}) do
    %{
      message: "Transfer done successfully",
      transfer: %{
        from_account: %{
          id: from_account.id,
          balance: from_account.balance
        },
        to_account: %{
          id: to_account.id,
          balance: to_account.balance
        }
      }
    }
  end
end
