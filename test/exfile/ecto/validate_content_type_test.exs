defmodule Exfile.Ecto.ValidateContentTypeTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset, only: [cast: 3]
  import Exfile.Ecto.ValidateContentType

  test "passes with correct content type" do
    changeset = cast(initial_changeset, %{ image: image_file }, [:image])
      |> validate_content_type(:image, ~w(image/jpeg))

    assert changeset.valid? == true
  end

  test "invalid with wrong content type" do
    changeset = cast(initial_changeset, %{ image: image_file }, [:image])
      |> validate_content_type(:image, ~w(video/mpeg))

    assert changeset.valid? == false
    assert changeset.errors == [image: {"invalid format", []}]
  end

  test "passes with no file" do
    changeset = cast(initial_changeset, %{}, [:image])
      |> validate_content_type(:image, ~w(image/jpeg))

    assert changeset.valid? == true
  end

  test "there are atoms for group of content types" do
    changeset = cast(initial_changeset, %{ image: image_file }, [:image])
      |> validate_content_type(:image, :image)

    assert changeset.valid? == true
  end

  defp initial_changeset do
    data  = %{ image: nil }
    types = %{ image: Exfile.Ecto.File }

    { data, types }
  end

  defp image_file do
    %Plug.Upload{ path: "test/fixtures/sample.jpg", filename: "sample.jpg" }
  end
end
