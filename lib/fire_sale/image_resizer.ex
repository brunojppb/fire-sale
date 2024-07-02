defmodule FireSale.ImageResizer.ResizedImage do
  @moduledoc """
    data bag for resized image during uploads
  """
  @enforce_keys [
    :original,
    :resized_path,
    :thumb_path,
    :width,
    :height,
    :resized_filename,
    :thumb_filename
  ]

  defstruct [
    :original,
    :resized_path,
    :thumb_path,
    :width,
    :height,
    :resized_filename,
    :thumb_filename
  ]

  @type t :: %__MODULE__{
          original: String.t(),
          resized_path: String.t(),
          resized_filename: String.t(),
          width: integer(),
          height: integer(),
          thumb_path: String.t(),
          thumb_filename: String.t()
        }
end

defmodule FireSale.ImageResizer do
  @moduledoc """
  Uses ImageMagick for resizing original images to a more affordable
  file size. This module prepares images for eventual uploads to S3.
  """
  alias Ecto.UUID
  alias FireSale.ImageResizer.ResizedImage

  @doc """
  Resize the given image to a smaller format and generates a thumb version of it.
  ## Parameters
  - `image_file`: File path to the original image for resizing
  """
  @spec resize_and_thumb(image_file :: String.t()) :: ResizedImage.t()
  def resize_and_thumb(image_file) do
    file_id = UUID.generate()
    {full_filename, thumb_filename} = {file_id <> ".jpg", "thumb_" <> file_id <> ".jpg"}
    upload_dir = temp_upload_dir()

    if not File.exists?(upload_dir) do
      File.mkdir!(upload_dir)
    end

    temp_full_img_path = upload_dir <> "/" <> full_filename
    temp_thumb_img_path = upload_dir <> "/" <> thumb_filename

    full_img_task =
      Task.async(fn ->
        {%Mogrify.Image{path: path}, %{width: width, height: height}} =
          resized_image(image_file, temp_full_img_path)

        {:ok, path, width, height}
      end)

    thumb_img_task =
      Task.async(fn ->
        {%Mogrify.Image{path: path}, %{width: width, height: height}} =
          thumb_image(image_file, temp_thumb_img_path)

        {:ok, path, width, height}
      end)

    [{:ok, resized_img, width, height}, {:ok, thumb_img, _thumb_width, _thumb_height}] =
      Task.await_many([
        full_img_task,
        thumb_img_task
      ])

    %ResizedImage{
      original: image_file,
      resized_path: resized_img,
      resized_filename: full_filename,
      width: width,
      height: height,
      thumb_path: thumb_img,
      thumb_filename: thumb_filename
    }
  end

  @doc """
  Remove resized images from the disk once they are
  not required during the request lifecycle.
  Always return `:ok`
  """
  @spec clear_resized_image(image :: ResizedImage.t()) :: :ok
  def clear_resized_image(%ResizedImage{} = image) do
    [image.resized_path, image.thumb_path]
    |> Enum.each(&File.rm/1)

    :ok
  end

  defp resized_image(image_path, path_to_save) do
    resize_image(image_path, path_to_save, "800x800")
  end

  defp thumb_image(image_path, path_to_save) do
    resize_image(image_path, path_to_save, "300x300")
  end

  defp resize_image(image_path, path_to_save, resize_limit) do
    image =
      Mogrify.open(image_path)
      |> Mogrify.format("jpg")
      |> Mogrify.resize_to_limit(resize_limit)
      |> Mogrify.save(path: path_to_save)

    info = Mogrify.identify(image.path)

    {image, info}
  end

  defp temp_upload_dir(), do: Application.app_dir(:fire_sale, Path.join("priv", "uploads"))
end
