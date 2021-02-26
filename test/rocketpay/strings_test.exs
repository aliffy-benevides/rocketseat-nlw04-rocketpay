defmodule Rocketpay.StringsTest do
  use ExUnit.Case

  alias Rocketpay.Strings

  describe "trim_and_to_lower/1" do
    test "when receive a word, returns a message with a trim and downcase word" do
      response = Strings.trim_and_to_lower("  QWEasdZXC  ")

      expected_response = "qweasdzxc"

      assert response == expected_response
    end
  end
end
