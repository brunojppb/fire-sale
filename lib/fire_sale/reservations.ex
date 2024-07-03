defmodule FireSale.Reservations do
  @moduledoc """
  The Reservations context.
  """

  import Ecto.Query, warn: false
  alias FireSale.Products.Product
  alias FireSale.Repo

  alias FireSale.Products.Reservation

  def reserve_product(product_id, attrs, reservation_url_fun) do
    query = from r in Reservation, where: r.product_id == ^product_id and r.status == "reserved"

    # I don't care if there are many reservations for a product,
    # but as long as there is at least one in status "reserved",
    # we should not reserve the product anymore.
    case Repo.one(query) do
      nil ->
        do_reserve_product(product_id, attrs, reservation_url_fun)

      _existing_reservetaion ->
        {:error, "product already reserved"}
    end
  end

  defp do_reserve_product(product_id, attrs, reservation_url_fun) do
    attrs =
      attrs
      |> Map.put("product_id", product_id)
      |> Map.put("status", "pending")

    case create_reservation(attrs) do
      {:ok, reservation} ->
        token = Base.url_encode64(reservation.token, padding: false)

        %{reservation_id: reservation.id, url: reservation_url_fun.(token)}
        |> FireSale.Worker.Mailman.new()
        |> Oban.insert()

        {:ok, reservation}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def confirm_reservation(token) do
    {:ok, token_binary} = Base.url_decode64(token, padding: false)
    # @TODO: Modify the query to actually fetch the product in a join
    # and double-check whether the product is alresady reserved.
    # join: p in Product,

    query =
      from r in Reservation,
        join: p in Product,
        on: r.product_id == p.id,
        where: r.token == ^token_binary,
        select: {r.id, p.id, p.reserved}

    case Repo.one(query) do
      nil ->
        {:error, "This confirmation is either invalid or has expired"}

      # @TODO
      # In case it is already reserved, then just deny it.
      # otherwise, mark the product as reserved for the user and update the product flag.
      {reservation_id, product_id, is_reserved} ->
        if is_reserved do
          {:error, "Sorry, This product has already been reserved by someone else."}
        else
          from(p in Product, where: p.id == ^product_id, update: [set: [reserved: true]])
          |> Repo.update_all([])

          from(r in Reservation,
            where: r.id == ^reservation_id,
            update: [set: [status: "confirmed"]]
          )
          |> Repo.update_all([])

          {:ok, "cool"}
        end
    end
  end

  @doc """
  Returns the list of reservations.

  ## Examples

      iex> list_reservations()
      [%Reservation{}, ...]

  """
  def list_reservations do
    Repo.all(Reservation)
  end

  @doc """
  Gets a single reservation.

  Raises `Ecto.NoResultsError` if the Reservation does not exist.

  ## Examples

      iex> get_reservation!(123)
      %Reservation{}

      iex> get_reservation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reservation!(id), do: Repo.get!(Reservation, id)

  @doc """
  Creates a reservation.

  ## Examples

      iex> create_reservation(%{field: value})
      {:ok, %Reservation{}}

      iex> create_reservation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reservation(attrs \\ %{}) do
    %Reservation{}
    |> Reservation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reservation.

  ## Examples

      iex> update_reservation(reservation, %{field: new_value})
      {:ok, %Reservation{}}

      iex> update_reservation(reservation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reservation(%Reservation{} = reservation, attrs) do
    reservation
    |> Reservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reservation.

  ## Examples

      iex> delete_reservation(reservation)
      {:ok, %Reservation{}}

      iex> delete_reservation(reservation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reservation(%Reservation{} = reservation) do
    Repo.delete(reservation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reservation changes.

  ## Examples

      iex> change_reservation(reservation)
      %Ecto.Changeset{data: %Reservation{}}

  """
  def change_reservation(%Reservation{} = reservation, attrs \\ %{}) do
    Reservation.changeset(reservation, attrs)
  end
end
