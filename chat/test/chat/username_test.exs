defmodule Chat.UsernameTest do
  use ExUnit.Case, async: true

  alias Chat.Username

  @tag :skip
  test "normalize/1" do
    assert Username.normalize("Jane") == Username.normalize("jane")
    assert Username.normalize("Jane") == Username.normalize("JANE")
    assert Username.normalize("übernåme_π") == Username.normalize("ÜBERNÅME_Π")
  end
end
