import consumer from "./consumer"
document.addEventListener('turbolinks:load', () => {
  const chat_room_element = document.getElementById('chat-room-id');
  const chat_room_id = chat_room_element.getAttribute('data-chat-room-id');

  console.log(consumer.subscriptions)

  consumer.subscriptions.subscriptions.forEach((subscription) => {
    consumer.subscriptions.remove(subscription)
  })

  consumer.subscriptions.create({ channel: "ChatRoomChannel", chat_room_id: chat_room_id }, {
    connected() {
      console.log("connected to chat_room_" + chat_room_id)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const user_element = document.getElementById('user-room-id');
      const user_id = Number(user_element.getAttribute('data-user-id'));

      let html;

      if (user_id === data.message.user_id) {
        html = data.mine
      } else {
        html = data.theirs
      }

      console.log(data);


      const messageContainer = document.getElementById('messages')
      console.log(messageContainer);

      messageContainer.innerHTML = messageContainer.innerHTML + html
    }
  });
})
