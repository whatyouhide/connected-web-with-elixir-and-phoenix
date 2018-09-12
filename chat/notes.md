# Notes

## Schedule

### Kickoff

  * `iex`
  * `mix test`
  * `mix test --include skip`
  * `mix phx.server` - visit `localhost:4000/`
  * `iex -S mix phx.server` - best friend

### 1: Normalizing usernames

#### Concepts

  * Elixir decouples data and behaviour
  * Data is just data
  * Functions are behaviour that operate on data
  * Functions live in modules

#### Action

Add a `Chat.Username` module with a `normalize/1` function.

#### Resources

```elixir
def normalize(username) when is_binary(username), do: String.downcase(username)
```

### 2: Phoenix components

#### Concepts

  * Router (`/`)
  * Controllers (`PageController`)
  * Views (only needed when more work than just render template)
  * Templates (actual rendering)

#### Action

Add a static page at `/about`.

Exercise parts:

  * Add route
    ```elixir
    get "/about", PageController, :about
    ```
  * Add `about/2` action in `PageController`
  * Add `about.html.eex` to the templates and fill it in with whatever you want
  * Add a link to `index.html.eex`: `<p><a href="/about">About</a></p>`

### 3: Channels

#### Concepts

  * Phoenix channels
  * Socket vs channels
  * Channel = process (explain benefits of processes)
  * Broadcasting
  * JavaScript side
  * Pattern matching for in `join`

#### Action

  * Route `room:*` to `RoomChannel` in `UserSocket`
  * Add `join("room:lobby", ...)` to `RoomChannel`
  * Show how `handle_in` for channels works
  * Connect to socket in `socket.js`:
    ```javascript
    let socket = new Socket("/socket", {})
    socket.connect()
    ```
  * Create the channel, join, and log joining:
    ```elixir
    let channel = socket.channel("room:lobby")

    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.error("Unable to join", resp) })
    ```
  * Talk about `channel.push` and `channel.on`

Exercise:

  * Add `messageInput.AddEventListener` where we `channel.push`
  * Add `handle_in/3` and broadcast `"new_message"` to the whole socket
  * Add `channel.on("new_message", message => {})`

Solution:

```javascript
messageInput.addEventListener('keypress', event => {
  if (event.key == "Enter" && messageInput.value.length > 0) {
    channel.push("new_message", {username: usernameInput.value, message: messageInput.value})
    messageInput.value = ""
  }
})

channel.on("new_message", message => {
  addMessage(message.username, message.message)
})
```

```elixir
def handle_in("new_message", %{"username" => username, "message" => message}, socket) do
  payload = %{"username" => Chat.Username.normalize(username), "message" => message}
  broadcast(socket, "new_message", payload)
  {:noreply, socket}
end
```

### 3.1: Alert with username

  * Add to `socket.channel`: `{username: prompt("Username?")}`
  * In `RoomChannel`, add this to `join("room:lobby", ...)`:
    ```elixir
    username =
      case String.trim(Map.fetch!(payload, "username")) do
        "" -> "anonymous"
        other -> Chat.Username.normalize(other)
      end

    socket = assign(socket, :username, username)
    send(self(), :after_join)
    ```
  * Change `handle_in` to use `socket.assigns[:username]`
  * Add this:
    ```elixir
    def handle_info(:after_join, socket) do
      broadcast!(socket, "user_joined", %{"username" => socket.assigns[:username]})
      {:noreply, socket}
    end
    ```
  * Add to `socket.js`:
    ```javascript
    channel.on("user_joined", message => {
      addMessage(message.username, "*joined*")
    })
    ```

### 4: Distributed

  * Distributed Elixir
  * Messages are the same through nodes
  * Phoenix channels are built on top of pub/sub
  * Distributed Pub/Sub
  * Distribution + pub/sub + channels

#### Action

  * Add `load_from_system_env: true` to the config
  * Add `sys.config` with contents:
    ```erlang
    [{kernel,
      [
        {sync_nodes_optional, ['n1@127.0.0.1', 'n2@127.0.0.1']},
        {sync_nodes_timeout, 10000}
      ]}
    ].
    ```
  * Start nodes with:
    ```
    PORT=4001 elixir --name n1@127.0.0.1 --erl "-config sys.config" -S mix phx.server
    ```
