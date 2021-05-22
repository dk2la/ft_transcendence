class Message < ApplicationRecord
    belongs_to :chat_room
    belongs_to :user
<<<<<<< HEAD
=======

    def str(message_receiver)
		if message_receiver == self.user
			"[\"#{self.user.nickname}\"]: #{self.content}"
		elsif message_receiver.blocked_users.find_by(cur: self.user) # elsif BlockedUser.find_by(user: message_receiver, towards: self.user)
			"[Blocked User]: generic message"
		else
            if self.user.guild != nil
                "[#{self.user.guild.anagram} #{self.user.nickname}]: #{self.content}"
            else
                "[\"#{self.user.nickname}\"]: #{self.content}"
            end
        end
	end
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
end
