import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const game_room_element = document.getElementById('game-id');
  const game_room_id = game_room_element.getAttribute('data-room-id')

  console.log(consumer.subscriptions)

  consumer.subscriptions.subscriptions.forEach((subscription) => {
    consumer.subscriptions.remove(subscription)
  })

consumer.subscriptions.create({ channel: "GameRoomChannel", room_id: game_room_id}, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to room " + game_room_id);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disnonnected from room" + game_room_id);
  },

  received(data) {
    
  }
});
})
