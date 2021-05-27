// FUCK FT_TRANSCENDENCE! ALL MY HOMIES HATE FT_TRANSCENDENCE
import consumer from "./consumer"
import Render from "../rendering/render"

let GameSub = null;
let mykeydown, mykeyup;
let KEY_SPACE = 32,
	ARROW_UP = 38,
	ARROW_DOWN = 40,
	KEY_S = 83,
	KEY_W = 87;
let input = "none";

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
    } else if (data["action"] == "redirect_after_destroy_room") {
        if (data["title"] == game_target_id)
          redirectAfterDestroy();
    } else if (data["action"] == "draw_rules") {
      console.log("I`AM DRAWING RULES")
        if (data["title"] == game_target_id)
          drawRules();
    } else if (data["action"] == "removeEvent") {
        console.log("REMOVE EVENT LIST");
        if (data["title"] == game_target_id)
          removeEvent();
    }
	}
}

function removeEvent() {
  document.removeEventListener('keydown', mykeydown);
  document.removeEventListener('keyup', mykeyup);
}

function drawRules() {
    // <h1 id="waiting-h1"> waiting second player </h1>
    console.log("HELLO IAM DRAWING RULE HERE");
    $('#waiting-h1').remove();
    $('#waiting-div').append('<h1 id="waiting-h1"> Press SPACE for start or pause game </h1>');
}

function redirectAfterDestroy() {
  console.log("GAME WAS DESTROYED");
  window.location.replace("/games");
}

function drawLayoutsPlayer(added_user, guild_anagram) {
  console.log("HELLO I`M HERE");
  const PLAYER_INFO_NO_GUILD = `<tr id="second-player"><td>${added_user["nickname"]}</td><td>[NO GUILD]</td><td>${added_user["rating"]}</td><td> RIGHT PADDLE </td></tr>`;
  const PLAYER_INFO_GUILD = `<tr id="second-player"><td>${added_user["nickname"]}</td><td>${guild_anagram}</td><td>${added_user["rating"]}</td><td> RIGHT PADDLE </td></tr>`;
  let html;

  if (guild_anagram)
    hmtl += PLAYER_INFO_GUILD;
  else
    html += PLAYER_INFO_NO_GUILD;
  console.log("HELLO I`M HERE");
  console.log(`This is html what i am added ${html}`);
  $('#list-players').append(html);
}

function removeStaleGameConnections() {
	consumer.subscriptions.subscriptions.forEach(sub => {
		if (sub.identifier && sub.identifier.includes("GameChannel")) {
			sub.disconnected();
			consumer.subscriptions.remove(sub);
		}
	})
}

function manageGameChannels() {
  let game_div = document.getElementById('game-room-id');
  let game_div_elem = game_div.getAttribute("data-game-room-id")
  if (game_div_elem === null)
    return removeStaleGameConnections();
  let render = new Render(document.getElementById("gamee"));

  let data = {
	  type: "none"
  };

  mykeydown = function(e) {
  	e.preventDefault();
  	if (e.keyCode === KEY_SPACE) {
  		data["type"] = "ready"
  		GameSub.perform('input', data);
	  } else if (e.keyCode === ARROW_UP || e.keyCode === KEY_W) {
		  input = "paddle_up";
	  } else if (e.keyCode === ARROW_DOWN || e.keyCode === KEY_S) {
			input = "paddle_down";
	  }
	}

	mykeyup = function(e) {
  	e.preventDefault();
  	input = "none";
	}

  console.log(`THIS IS game_div, I AM HERE ${game_div}`);
  GameSub = consumer.subscriptions.create({channel: "GameRoomChannel", game_room: game_div.getAttribute("data-game-room-id")}, {
    connected: () => {
      console.log("connected to game_room_" + GameSub.identifier);
      document.addEventListener('keydown', mykeydown);
      document.addEventListener('keyup', mykeyup);
    },

    disconnected: () => {
      console.log("disconnectrd from game_room_" + GameSub.identifier);
      document.removeEventListener('keydown', mykeydown);
      document.removeEventListener('keyup', mykeyup);
    },

    received: (data) => {
      console.log("AAAALLLLOOO HUILO")
      if (data["action"] == "draw_players" || data["action"] == "redirect_after_destroy_room" || data["action"] == "removeEvent" || data["action"] == "drawRules") {
        received_data(data, document.getElementById('game-room-id'));
      }
      console.log(data);
      if (data.config) {
        console.log("Rendering config")
        render.config(data.config);
      }
		  if (input !== "none") {
		  	data["type"] = input;
		  	GameSub.perform('input', data);
		  }
    }
  });
}

window.addEventListener("hashchange", e => {
  setTimeout(manageGameChannels, 250);
})

window.addEventListener("turbolinks:load", () => {
  setTimeout(manageGameChannels, 250);
  console.log("LOL");
})