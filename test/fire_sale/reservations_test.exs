defmodule FireSale.ReservationsTest do
  alias FireSale.ReservationsFixtures
  use FireSale.DataCase

  alias FireSale.Reservations

  describe "reservations" do
    alias FireSale.Products.Reservation

    import FireSale.ReservationsFixtures

    @invalid_attrs %{name: nil, status: nil, token: nil, phone: nil, email: nil}

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      assert Reservations.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      assert Reservations.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data creates a reservation" do
      valid_attrs = %{
        name: "some name",
        status: "some status",
        token: "some token",
        phone: "some phone",
        email: ReservationsFixtures.unique_email(),
        product_id: FireSale.ProductsFixtures.product_fixture().id
      }

      assert {:ok, %Reservation{} = reservation} = Reservations.create_reservation(valid_attrs)
      assert reservation.name == "some name"
      assert reservation.status == "some status"
      assert reservation.token == "some token"
      assert reservation.phone == "some phone"
      assert reservation.email == valid_attrs.email
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reservations.create_reservation(@invalid_attrs)
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()

      update_attrs = %{
        name: "some updated name",
        status: "some updated status",
        token: "some updated token",
        phone: "some updated phone",
        email: "my_new_email@example.com"
      }

      assert {:ok, %Reservation{} = reservation} =
               Reservations.update_reservation(reservation, update_attrs)

      assert reservation.name == "some updated name"
      assert reservation.status == "some updated status"
      assert reservation.token == "some updated token"
      assert reservation.phone == "some updated phone"
      assert reservation.email == "my_new_email@example.com"
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Reservations.update_reservation(reservation, @invalid_attrs)

      assert reservation == Reservations.get_reservation!(reservation.id)
    end

    test "delete_reservation/1 deletes the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{}} = Reservations.delete_reservation(reservation)
      assert_raise Ecto.NoResultsError, fn -> Reservations.get_reservation!(reservation.id) end
    end

    test "change_reservation/1 returns a reservation changeset" do
      reservation = reservation_fixture()
      assert %Ecto.Changeset{} = Reservations.change_reservation(reservation)
    end
  end
end
