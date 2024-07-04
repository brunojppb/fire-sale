defmodule FireSale.Products.ReservationNotifier do
  @moduledoc """
  Notification dispatcher for product reservations
  """
  import Swoosh.Email

  alias FireSale.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from(sender_email())
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_reservation_instructions(name, email, product_name, url) do
    deliver(email, "Confirm your reservation", """
    Hi #{name},

    Thanks for your interested in our little garage sale.
    In order to confirm your reservation for the #{product_name}, click on the link below:

    #{url}

    If you didn't reserve this product, please ignore this.

    Best,
    Bruno Paulino
    """)
  end

  defp sender_email() do
    {"bruno", Application.fetch_env!(:fire_sale, :email)}
  end
end
