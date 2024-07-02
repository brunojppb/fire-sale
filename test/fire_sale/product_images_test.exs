defmodule FireSale.ProductImagesTest do
  use FireSale.DataCase

  alias FireSale.ProductImages

  describe "product_images" do
    alias FireSale.Products.ProductImage

    import FireSale.ProductImagesFixtures

    @invalid_attrs %{name: nil}

    test "list_product_images/0 returns all product_images" do
      product_image = product_image_fixture()
      assert ProductImages.list_product_images() == [product_image]
    end

    test "get_product_image!/1 returns the product_image with given id" do
      product_image = product_image_fixture()
      assert ProductImages.get_product_image!(product_image.id) == product_image
    end

    test "create_product_image/1 with valid data creates a product_image" do
      valid_attrs = %{
        name: "some name",
        width: 10,
        height: 10,
        product_id: FireSale.ProductsFixtures.product_fixture().id
      }

      assert {:ok, %ProductImage{} = product_image} =
               ProductImages.create_product_image(valid_attrs)

      assert product_image.name == "some name"
    end

    test "create_product_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductImages.create_product_image(@invalid_attrs)
    end

    test "update_product_image/2 with valid data updates the product_image" do
      product_image = product_image_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %ProductImage{} = product_image} =
               ProductImages.update_product_image(product_image, update_attrs)

      assert product_image.name == "some updated name"
    end

    test "update_product_image/2 with invalid data returns error changeset" do
      product_image = product_image_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ProductImages.update_product_image(product_image, @invalid_attrs)

      assert product_image == ProductImages.get_product_image!(product_image.id)
    end

    test "delete_product_image/1 deletes the product_image" do
      product_image = product_image_fixture()
      assert {:ok, %ProductImage{}} = ProductImages.delete_product_image(product_image)

      assert_raise Ecto.NoResultsError, fn ->
        ProductImages.get_product_image!(product_image.id)
      end
    end

    test "change_product_image/1 returns a product_image changeset" do
      product_image = product_image_fixture()
      assert %Ecto.Changeset{} = ProductImages.change_product_image(product_image)
    end
  end
end
