defmodule FireSale.Storage.FileStore do
  @moduledoc """
  Behavior for managing file uploads and reads to any given data store
  """
  @type t :: module()

  @doc """
  Copy the given file to a data storage.
  Returns the filename in case of success.
  """
  @callback put_file(temp_file_path :: String.t(), filename :: String.t()) ::
              FireSale.result(String.t())

  @doc """
  Store the given binary data to a data storage.
  Returns the filename in case of success.
  """
  @callback put_data(data :: binary(), filename :: String.t()) :: FireSale.result(String.t())

  @doc """
  Get the given file and return a stream that can
  be passed down to the client.
  """
  @callback get_file(filename :: String.t()) :: FireSale.result(Enumerable.t())

  @doc """
  Delete the given file.
  Return the deleted filename in case of success
  """
  @callback delete_file(filename :: String.t()) :: FireSale.result(String.t())

  @spec put_file(temp_file_path :: String.t(), filename :: String.t()) ::
          FireSale.result(String.t())
  def put_file(temp_file_path, filename), do: impl().put_file(temp_file_path, filename)

  @spec put_data(data :: binary(), filename :: String.t()) :: FireSale.result(String.t())
  def put_data(data, filename), do: impl().put_data(data, filename)

  @spec get_file(filename :: String.t()) :: FireSale.result(Stream)
  def get_file(filename), do: impl().get_file(filename)

  @spec delete_file(filename :: String.t()) :: FireSale.result(String.t())
  def delete_file(filename), do: impl().delete_file(filename)

  @spec impl() :: __MODULE__.t()
  defp impl() do
    Application.get_env(:fire_sale, :file_store, FireSale.Storage.LocalFileStore)
  end
end
