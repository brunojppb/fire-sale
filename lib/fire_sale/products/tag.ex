defmodule FireSale.Products.Tag do
  @moduledoc """
  Handling of tags from and into the database
  taking it a simple csv-like input from our frontend.
  For more about Ecto custom types, see the [Ecto.Type behaviour](https://hexdocs.pm/ecto/Ecto.Type.html)
  """
  use Ecto.Type
  def type, do: {:array, :string}

  def cast(str) when is_binary(str) do
    {:ok, csvfy_tags(str)}
  end

  # def cast(data) when is_list(data) do
  #   {:ok, data}
  # end

  def cast(_), do: :error

  def load(data) do
    {:ok, data}
  end

  def dump(tags) when is_list(tags) do
    {:ok, tags}
  end

  def dump(_), do: :error

  defp csvfy_tags(str) do
    str
    |> String.split(",")
    |> Enum.reject(fn str -> str == "" || str == " " end)
    |> Enum.map(fn str -> String.trim(str) end)
    |> Enum.map(fn str -> String.replace(str, " ", "-") end)
  end
end
