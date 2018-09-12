defmodule ChatWeb.RoomChannelTest do
  use ChatWeb.ChannelCase

  alias ChatWeb.RoomChannel

  @tag :skip
  test "new message posted to room:lobby" do
    {:ok, _, socket} = subscribe_and_join(socket(), RoomChannel, "room:lobby", %{"username" => "foo"})
    payload = %{"username" => "foo", "message" => "hello"}
    push(socket, "new_message", payload)
    assert_broadcast("new_message", ^payload)
  end
end
