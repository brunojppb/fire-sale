defmodule FireSale.ProductsTest do
  use FireSale.DataCase

  alias FireSale.Products
  alias FireSale.Products.Product

  import FireSale.AccountsFixtures
  import FireSale.ProductsFixtures

  describe "products" do
    @invalid_attrs %{name: nil, description: nil, price: nil, tags: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert length(Products.list_products()) == 1
      assert List.first(Products.list_products()).id == product.id
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        price: "120.5",
        tags: "option1,option2",
        user_id: user_fixture().id
      }

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.price == Decimal.new("120.5")
      assert product.tags == ["option1", "option2"]
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: "456.7",
        tags: "option1"
      }

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.price == Decimal.new("456.7")
      assert product.tags == ["option1"]
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
