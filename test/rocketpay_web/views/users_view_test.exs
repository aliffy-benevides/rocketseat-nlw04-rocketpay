defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View   # import the render method

  alias Rocketpay.{User, Account}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Aliffy",
      password: "123456",
      nickname: "benevides",
      email: "aliffy@banana.com",
      age: 27
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} = Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.0"),
          id: account_id
        },
        id: user_id,
        name: "Aliffy",
        nickname: "benevides"
      }
    }

    assert response == expected_response
  end
end
