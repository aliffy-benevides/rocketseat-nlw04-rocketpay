defmodule RocketpayWeb.FallbackController do
  use RocketpayWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView) # Escolhe o módulo de View que se quer usar
    |> render("400.json", result: result)
  end
end
