defmodule FireSaleWeb.ProductImageController do
  use FireSaleWeb, :controller

  def show(conn, %{"filename" => filename}) do
    # All our uploads are public by default,
    # so we don't have to check for ownership
    FireSale.Storage.FileStore.get_file(filename)
    |> stream_resp(conn)
  end

  defp stream_resp({:error, _}, conn) do
    send_resp(conn, 404, "Error 404: Image not found")
  end

  defp stream_resp({:ok, stream}, conn) do
    conn
    |> put_resp_content_type("image/jpeg")
    # Cache for 6 months
    |> put_resp_header("cache-control", "public, max-age=15778476")
    |> send_chunked(200)
    |> send_chunked_stream(stream)
  end

  defp send_chunked_stream(conn, stream) do
    Enum.reduce_while(stream, conn, fn chunk, conn ->
      case chunk(conn, chunk) do
        {:ok, conn} ->
          {:cont, conn}

        {:error, :closed} ->
          {:halt, conn}
      end
    end)
  end
end
