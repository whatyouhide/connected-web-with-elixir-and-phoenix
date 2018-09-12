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
// TODO: implement

// Now that you are connected, you can join channels with a topic:
// TODO: implement

// To push to a channel:
//
//   channel.push("some_message", {some: "payload"})
//
// To handle events:
//
//   channel.on("message", message => {})
//

// To intercept keypresses:
//
//   messageInput.addEventListener('keypress', event => { ... })
//
// Note that enter has event.key == "Enter".

export default socket
