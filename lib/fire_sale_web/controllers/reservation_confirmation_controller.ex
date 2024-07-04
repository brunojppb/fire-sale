defmodule FireSaleWeb.ReservationConfirmationController do
  alias FireSale.Reservations
  use FireSaleWeb, :controller
  require Logger

  def show(conn, %{"token" => token}) do
    Logger.info("Product confirmation received: #{token}")

    case Reservations.confirm_reservation(token) do
      {:ok, _reservation} ->
        conn
        |> put_flash(
          :info,
          "The product has been reserved successfuly. We will reach out to you."
        )
        |> redirect(to: ~p"/")

      {:error, msg} ->
        conn
        |> put_flash(
          :error,
          msg
        )
        |> redirect(to: ~p"/")
    end
  end
end
