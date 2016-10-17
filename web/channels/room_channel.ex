defmodule Chat.RoomChannel do
	use Chat.Web, :channel
	alias Chat.Presence

	def join("room:lobby", _, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
  	IO.puts "===="
  	IO.inspect socket
  	IO.puts "===="
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
      # online_at: inspect(:os.timestamp())
    })

    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end
end