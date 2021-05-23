// FUCK FT_TRANSCENDENCE! ALL MY HOMIES HATE FT_TRANSCENDENCE
import consumer from "./consumer"
let GameSub = null;

function received_data(data, game_div) {
  if (!game_div)
    return;
  let game_target_id = game_div.getAttribute("data-game-room-id");
	if (data !== null && game_target_id !== "0")
  {
    if (data["action"] == "draw_players") {
      console.log(`CURRENT USER === ${data["added_user"]["nickname"]}, TYPEOF RECEIVER_ROLE === ${typeof(data["receiver_role"])}`);
      if (data["title"] === game_target_id)
        drawLayoutsPlayer(data["added_user"], data["guild_anagram"]);
    }
	}
}

function drawLayoutsPlayer(added_user, guild_anagram) {
  console.log("HELLO I`M HERE");
  const PLAYER_INFO_NO_GUILD = `<tr id="second-player"><td>${added_user["nickname"]}</td><td>[NO GUILD]</td><td>${added_user["rating"]}</td><td> 0 </td></tr>`;
  const PLAYER_INFO_GUILD = `<tr id="second-player"><td>${added_user["nickname"]}</td><td>${guild_anagram}</td><td>${added_user["rating"]}</td><td> 0 </td></tr>`;
  let html;

  if (guild_anagram)
    hmtl += PLAYER_INFO_GUILD;
  else
    html += PLAYER_INFO_NO_GUILD;
  console.log("HELLO I`M HERE");
  console.log(`This is html what i am added ${html}`);
  $('#list-players').append(html);
}

function manageGameChannels() {
  let game_div = document.getElementById('game-room-id');
  console.log(`THIS IS game_div, I AM HERE ${game_div}`);
  if (game_div !== null) {  
    GameSub = consumer.subscriptions.create({channel: "GameRoomChannel", game_room: game_div.getAttribute("data-game-room-id")}, {
      connected: () => {
        console.log("connected to game_room_" + GameSub.identifier);
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