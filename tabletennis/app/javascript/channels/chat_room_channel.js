// FUCK FT_TRANSCENDENCE! ALL MY HOMIES HATE FT_TRANSCENDENCE
import consumer from "./consumer"
let ChatSub = null;
let last_message = null;


function received_data(data, chat_div) {
  if (!chat_div)
    return;
  let chat_target_id = chat_div.getAttribute("data-chat-room-id");
	if (data !== null && chat_target_id !== "0")
  {
    if (data["action"] == "join_chat_room") {
      console.log(`CURRENT USER === ${data["added_user"]["nickname"]}, MEMBER ROLE === ${data["receiver_role"]}, TYPEOF RECEIVER_ROLE === ${typeof(data["receiver_role"])}`);
      if (data["title"] == chat_target_id)
        drawLayoutsMember(data["added_user"], data["receiver_role"], data["chat_id"], data["receiver_id"], data["guild_anagram"])
    } else if (data["action"] == "unmute") {
        if (data["title"] == chat_target_id)
          unmuteLayouts();
    } else if (data["action"] == "mute_member_from_owner") {
        if (data["title"] == chat_target_id)
          muteLayouts();
    } else if (data["action"] == "leave_chat_room_owner") {
        if (data["title"] == chat_target_id)
          leaveChatRoomOwner();
    } else if (data["action"] == "ban_user_redirect") {
        if (data["title"] == chat_target_id)
          bannedUserRedirect();
    } else if (data["action"] == "ban_user_append") {
        if (data["title"] == chat_target_id)
          banLayoutsMember(data["banned_user"], data["guild_anagram"]);
    } else if (data["action"] == "leave_chat_room") {
        if (data["title"] == chat_target_id)
          removeLayoutsMember(data["leave_user_id"]);
    } else if (data["action"] == "send_message") {
      if (last_message && JSON.stringify(data) === JSON.stringify(last_message))
        return;
      last_message = data;
      if (data["title"] === chat_target_id)
        $('#messages').append("<br>" + data["body"]);
    }
	}
}

function unmuteLayouts() {
  const INPUT_PLACEHOLDER = '<input placeholder="Type your message here..." class="text_sign_up" type="text" name="message[content]" id="message_content">';
  const INPUT_SUBMIT = '<input type="submit" name="commit" value="Add Message" class="button_edit_profile" id="chat-btn" data-disable-with="Add Message">';

  $('#aboba').append(INPUT_PLACEHOLDER);
  $('#aboba').append(INPUT_SUBMIT);
}

function muteLayouts() {
  $('#chat-btn').remove();
  $('#message_content').remove();
}

function leaveChatRoomOwner() {
  window.location.replace("/chat_rooms");
  console.log("HELLO PIDOR CHAT WAS DESTROYED");
}

function bannedUserRedirect() {
  window.location.replace("/chat_rooms");
  console.log("HELLO PIDOR");
}

function banLayoutsMember(banned_user, guild_anagram) {
  const MEMBER_INFO_NO_GUILD = `<tr id="banned-room-${banned_user["id"]}"><td>${banned_user["nickname"]}</td><td>[NO GUILD]</td><td>${banned_user["rating"]}</td>`;
  const MEMBER_INFO_GUILD = `<tr id="banned-room-${banned_user["id"]}"><td>${banned_user["nickname"]}</td><td>${guild_anagram}</td><td>${banned_user["rating"]}</td>`;
  const VIEW_PROFILE = `<td><a class="button_make_officer" href='/list_players/${banned_user["id"]}'>View Profile</td>`;
  let html
  $(`#member-room-${banned_user["id"]}`).remove();
  if (banned_user["guild"]) {
    html += MEMBER_INFO_GUILD; html += VIEW_PROFILE;
  } else {
    html += MEMBER_INFO_NO_GUILD; html += VIEW_PROFILE;
  }
  $('#list-banned').append(html);
  console.log(`HERE WE SEE ${html}, FOR BANNED USERS`);
}

function removeLayoutsMember(leave_user_id) {
  $(`#member-room-${leave_user_id}`).remove();
  console.log(`user id: ${leave_user_id}, block deleted`);
}

function drawLayoutsMember(added_user, receiver_role, chat_id, current_id, guild_anagram) {
  const MEMBER_INFO_NO_GUILD = `<tr id="member-room-${added_user["id"]}"><td>${added_user["nickname"]}</td><td>[NO GUILD]</td><td>member</td><td>${added_user["rating"]}</td>`;
  const MEMBER_INFO_GUILD = `<tr id="member-room-${added_user["id"]}"><td>${added_user["nickname"]}</td><td>${guild_anagram}</td><td>member</td><td>${added_user["rating"]}</td>`;
  const VIEW_PROFILE = `<a class="button_menu_chat" href='/list_players/${added_user["id"]}'>View Profile`;
  const BAN_MEMBER = `<a class="button_menu_chat" href='/chat_rooms/ban_user?id=${added_user["id"]}&chat_id=${chat_id}'>Ban`;
  const MUTE_MEMBER = `<a class="button_menu_chat" href='/chat_rooms/mute_member?id=${added_user["id"]}&chat_id=${chat_id}&current_id=${current_id}'>Mute`;
  const SET_MODERATOR = `<a class="button_menu_chat" href='/chat_rooms/set_moderator?id=${added_user["id"]}&chat_id=${chat_id}'>Make officer`;
  const BLOCK_MEMBER = `<a class="button_menu_chat" href='/chat_rooms/block_user?target_id=${added_user["id"]}&chat_id=${chat_id}&current_id=${current_id}'>Block</tr>` + `</td></div></div>`;
  let html;

  let block = document.getElementById(`member-room-${added_user["id"]}`);
  if (block != null) {
    console.log('fuck ft_transcendence');
    return;
  }
  if (receiver_role == "owner") {
    if (added_user["guild"]) {
      html += MEMBER_INFO_GUILD; html += `<td><div class="dropup"><button class="dropbtn">Info</button><div class="dropup-content">`; html += VIEW_PROFILE; html += BAN_MEMBER; html += MUTE_MEMBER; html += SET_MODERATOR; html += BLOCK_MEMBER;
    } else {
      html += MEMBER_INFO_NO_GUILD; html += `<td><div class="dropup"><button class="dropbtn">Info</button><div class="dropup-content">`; html += VIEW_PROFILE; html += BAN_MEMBER; html += MUTE_MEMBER; html += SET_MODERATOR; html += BLOCK_MEMBER;
    }
  } else if (receiver_role == "moderator") {
    if (added_user["guild"]) {
      html += MEMBER_INFO_GUILD; html += `<td><div class="dropup"><button class="dropbtn">Info</button><div class="dropup-content">`; html += VIEW_PROFILE; html += BAN_MEMBER; html += MUTE_MEMBER; html += BLOCK_MEMBER;
    } else {
      html += MEMBER_INFO_NO_GUILD; html += `<td><div class="dropup"><button class="dropbtn">Info</button><div class="dropup-content">`; html += VIEW_PROFILE; html += BAN_MEMBER; html += MUTE_MEMBER; html += BLOCK_MEMBER;
    }
  } else {
    if (added_user["guild"]) {
      html += MEMBER_INFO_GUILD; html += `<td><div class="dropup"><button class="dropbtn">Info</button><div class="dropup-content">`; html += VIEW_PROFILE; html += BLOCK_MEMBER;
    } else {
      html += MEMBER_INFO_NO_GUILD; html += `<td><div class="dropup"><button class="dropbtn">Info</button><div class="dropup-content">`; html += VIEW_PROFILE; html += BLOCK_MEMBER;
    }
  }
  console.log(`HERE WE SEE ${html}`);
  $('#list-members').append(html);
}

function manageChatChannels() {
  let chat_div = document.getElementById('chat-room-id');
  console.log(`THIS IS CHAT_DIV, I AM HERE ${chat_div}`);
  if (chat_div !== null) {  
    ChatSub = consumer.subscriptions.create("ChatRoomChannel", {
      connected: () => {
        console.log("connected to chat_room_" + ChatSub.identifier);
      },

      disconnected: () => {
        console.log("disconnectrd from chat_room_" + ChatSub.identifier);
      },

      received: (data) => {
        console.log("AAAALLLLOOO HUILO")
        let chatBtn = document.getElementById('chat-btn');
        chatBtn.disabled = false;

        let chatBox = document.getElementById('message_content');
        chatBox.value = '';
        received_data(data, document.getElementById('chat-room-id'));
      }
    });
  } else {
    consumer.subscriptions.subscriptions.forEach(sub => {
      if (sub.identifier && sub.identifier.includes("ChatChannel")) {
        sub.disconnected();
        consumer.subscriptions.remove(sub);
      }
    })
  }
}

window.addEventListener("hashchange", e => {
  setTimeout(manageChatChannels, 250);
})

window.addEventListener("turbolinks:load", () => {
  setTimeout(manageChatChannels, 250);
  console.log("LOL");
})
