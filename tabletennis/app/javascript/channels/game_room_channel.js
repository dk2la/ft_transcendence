import consumer from "./consumer"

var zalupa = consumer.subscriptions.create("GameRoomChannel", {
    connected() {
      setTimeout(() => {let kek = "kek"}, 1000);
      // Called when the subscription is ready for use on the server
      consumer.subscriptions.remove(zalupa);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel\
      console.log(data);
    }
  });
