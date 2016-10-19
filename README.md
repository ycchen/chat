# Chat

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

mix phoneix.new chat

mix ecto.create

mix phoenix.server

## Tracking online users with Phoenix Presence

mix phoenix.gen.presence

Use Presence module to track who's currently online in your chat room.

--/lib/chat.ex

Add supervisor(Chat.Presence, [])

Add web/channels/room_channel.ex


** Addcluster of nodes

https://dockyard.com/blog/2016/01/28/running-elixir-and-phoenix-projects-on-a-cluster-of-nodes

Create sys.config in root of the project

// sys.config
[{kernel,
  [
    {sync_nodes_optional, ['n1@127.0.0.1', 'n2@127.0.0.1']},
    {sync_nodes_timeout, 10000}
  ]}
].

// Modify config/dev.exs

http: [port: System.get_env("PORT") || 4000],

** Start project with following commands

$ PORT=4001 elixir --name n1@127.0.0.1 --erl "-config sys.config" -S mix phoenix.server

$ PORT=4002 elixir --name n2@127.0.0.1 --erl "-config sys.config" -S mix phoenix.server


### Node.disconnect

$ PORT=4001 iex --name n1@127.0.0.1 --erl "-config sys.config" -S mix phoenix.server

$ PORT=4002 iex --name n2@127.0.0.1 --erl "-config sys.config" -S mix phoenix.server

#disconnect the communicate between n1 and n2
> Node.disconnect(:"n1@127.0.0.1")

Both n1 and n2 has new user join

# reconnect the communicate between n1 and n2
> Node.connect(:n1@127.0.0.1)

http://work.stevegrossi.com/2016/07/11/building-a-chat-app-with-elixir-and-phoenix-presence/

Phoenix Presence sneak peek – step-by-step walkthrough

https://www.youtube.com/watch?v=9dALrnCOLNE


mix phoenix.new demo --no-ecto

cd demo

git init .

### generate presence

mix phoenix.gen.presence

creating web/channels/presence.ex

### add supervisor(Demo.Presence, []), in demo/lib/demo.ex

### run the server to make sure there is no error

mix phoenix.server

### modify web/templates/page/index.html to set up display user html area

<h2> <%= node() %> </h2>
<ul id="user-list"></ul>

### to show user we will need a channel, let's create web/channels/room_channel.ex

defmodule Demo.RoomChannel do
	use Demo.Web, :channel
	alias Demo.Presence

	def join("room:lobby", _, socket) do
		send self(),  :after_join
		{:ok, socket}
	end

	def handle_info(:after_join, socket) do
		Presence.track(socket, socket.assigns.user_id, %{
			device: "browser",
			online_at: inspect(:os.timestamp())
		})

		push socket, "presence_state", Presence.list(socket)

		{:noreply, socket}
	end
end

\\ web/channels\user_socket.ex

channel "room:lobby", Demo.RoomChannel

def connect(%{user_id => id}, socket) do
	{:ok, assign(socket, :user_id, id)}
end

\\ app.js
import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", params:{user_id: window.userId}})

socket.connect()

let userList = document.getElementById("user-list")
room = sockect.channdel("rooms:lobby", {})
let presences = {}

let listBy = (id, {metas: [first, ...rest]}) =>{
	first.name = id
	first.count rest.length + 1
	return first
}
let render = (presences) =>{
	userList.innerHTML = Presence.list(presences, listBy)
		.map{user => `<li>${user.name} (${user.count})`}	
		.join("")
}

room.on("presence_state", state =>{
	presence = Presence.syncState(presences, state)
	render(presences)
})

room.on("presence_diff", diff =>{
	presence = Presence.syncDiff(presences, diff)
	render(presences)
})

room.join()


\\ /web/templates/layout/app.html.eex - add following at the bottom

<script>
window.userId = "<%= @conn.params["name"]%>"
</script>

** Running Elixir and Phoenix projects on a cluster of nodes

https://dockyard.com/blog/2016/01/28/running-elixir-and-phoenix-projects-on-a-cluster-of-nodes

Source Code:

https://github.com/chrismccord/phoenix_presence_example
