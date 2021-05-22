// FUCK FT_TRANSCENDENCE! ALL MY HOMIES HATE FT_TRANSCENDENCE
import consumer from "./consumer"
let GameSub = null;
let game = null;

function received_data(data, game_div) {
  if (!game_div)
    return;
  let game_target_id = game_div.getAttribute("data-game-room-id");
	if (data !== null && game_target_id !== "0")
  {
    if (data["action"] == "draw_players") {
      if (data["title"] === game_target_id)
        $('#messages').append("<br>" + data["body"]);
    }
	}
}

function manageGameChannels() {
  let game_div = document.getElementById('game-room-id');
  console.log(`THIS IS game_div, I AM HERE ${game_div}`);
  if (game_div !== null) {  
    GameSub = consumer.subscriptions.create("GameRoomChannel", {
      connected: () => {
        console.log("connected to game_room_" + GameSub.identifier);
        inter = setInterval(() =>{
          canvas = document.getElementById("myCanvas");
          if (canvas != null) {
            ctx = canvas.getContext('2d');
            game.draw_datas();
            clearInterval(inter);
          }
        }, 80);

      },

      disconnected: () => {
        console.log("disconnectrd from game_room_" + GameSub.identifier);
      },

      received: (data) => {
        console.log("AAAALLLLOOO HUILO")
        received_data(data, document.getElementById('game-room-id'));
      }
    });
  } else {
    consumer.subscriptions.subscriptions.forEach(sub => {
      if (sub.identifier && sub.identifier.includes("GameChannel")) {
        sub.disconnected();
        consumer.subscriptions.remove(sub);
      }
    })
  }
}

window.addEventListener("hashchange", e => {
  setTimeout(manageGameChannels, 250);
})

window.addEventListener("turbolinks:load", () => {
  setTimeout(manageGameChannels, 250);
  console.log("LOL");
})