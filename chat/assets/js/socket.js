import {Socket} from "phoenix"

var messageList = document.getElementById("messages")
var usernameInput = document.getElementById("username")
var messageInput = document.getElementById("message")

// Adds a message with text "text" from username "username" to the
// list of messages and renders it.
const addMessage = (username, message) => {
  let name = username || "anonymous"
  let messageElement = document.createElement("li")
  messageElement.innerHTML = `<a href='#'>[${username || "anonymous"}]</a>&nbsp; ${message}`
  messageList.appendChild(messageElement)
  scrollTo(0, document.body.scrollHeight)
}

// Connect at the socket path in "lib/web/endpoint.ex":
let socket = new Socket("/socket", {})
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:lobby", {username: prompt('Username?')})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.error("Unable to join", resp) })

// To push to a channel:
//
//   channel.push("some_message", {some: "payload"})
//
// To handle events:
//
//   channel.on("message", message => {})
//

messageInput.addEventListener('keypress', event => {
  if (event.key == "Enter" && messageInput.value.length > 0) {
    channel.push("new_message", {username: usernameInput.value, message: messageInput.value})
    messageInput.value = ""
  }
})

channel.on("new_message", message => {
  addMessage(message.username, message.message)
})

channel.on("user_joined", message => {
  addMessage(message.username, "*joined*")
})

export default socket
