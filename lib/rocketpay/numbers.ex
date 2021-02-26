defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    # file = File.read("#{filename}.csv")
    # handle_file(file)

    # |> (pipe operator) - pega o retorno linha anterior e passa como primeiro parâmetro da função
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, result}) do
    sum =
      String.split(result, ",")
      |> Stream.map(fn number -> String.to_integer(number) end)
      |> Enum.sum()

    {:ok, %{result: sum}}
  end
  defp handle_file({:error, _reason}), do: {:error, "Invalid file!"}
end
