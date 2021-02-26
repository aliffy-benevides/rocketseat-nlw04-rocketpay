defmodule RocketpayWeb.ChallengesController do
  use RocketpayWeb, :controller

  alias Rocketpay.Strings

  def challenge1(conn, %{"word" => word}) do
    word
    |> Strings.trim_and_to_lower()
    |> handle_response(conn)
  end

  defp handle_response(word, conn) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Your word processed is #{word}"})
  end
end
