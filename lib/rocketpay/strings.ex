defmodule Rocketpay.Strings do
  def trim_and_to_lower(word) do
    word
    |> String.trim()
    |> String.downcase()
  end
end
