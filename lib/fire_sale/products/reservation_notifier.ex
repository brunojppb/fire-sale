defmodule FireSale.Products.ReservationNotifier do
  @moduledoc """
  Notification dispatcher for product reservations
  """
  import Swoosh.Email

  require Logger
  alias FireSale.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from(sender_email())
      |> subject(subject)
      |> text_body(body)

    case Mailer.deliver(email) do
      {:ok, metadata} ->
        Logger.info("Mail sent to email=#{recipient} meta=#{inspect(metadata)}")
        {:ok, email}

      {:error, error} ->
        Logger.error("Could not deliver the email #{inspect(error)}")
        {:error, error}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_reservation_instructions(name, email, product_name, url) do
    deliver(email, "Confirm your reservation", """
    Hi #{name},

    Thanks for your interest in our little garage sale.
    In order to confirm your reservation for the product "#{product_name}", click on the link below:

    #{url}

    If you didn't reserve this product, please ignore this.

    Best,
    Bruno
    """)
  end

  defp sender_email() do
    {"bruno", Application.fetch_env!(:fire_sale, :email)}
  end
end
