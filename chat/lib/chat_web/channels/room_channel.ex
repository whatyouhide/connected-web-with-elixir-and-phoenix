defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel

  def join("room:lobby", payload, socket) do
    username =
      case String.trim(Map.fetch!(payload, "username")) do
        "" -> "anonymous"
        other -> Chat.Username.normalize(other)
      end

    socket = assign(socket, :username, username)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("new_message", %{"message" => message}, socket) do
    payload = %{"username" => socket.assigns[:username], "message" => message}
    broadcast(socket, "new_message", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "user_joined", %{"username" => socket.assigns[:username]})
    {:noreply, socket}
  end
end
