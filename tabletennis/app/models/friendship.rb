class Friendship < ApplicationRecord
    belongs_to :user

    def self.reacted?(id1, id2)
        puts "FRIENDSHIP\n\n\n\n\n\n"
        case1 = !Friendship.where(user_id: id1, friend_id: id2).empty?
        case2 = !Friendship.where(user_id: id2, friend_id: id1).empty?
        puts case1 || case2 ? "true" : "false"
        puts "-"
        case1 || case2
      end
    
      def self.confirmed_record?(id1, id2)
        case1 = !Friendship.where(user_id: id1, friend_id: id2, confirmed: true).empty?
        case2 = !Friendship.where(user_id: id2, friend_id: id1, confirmed: true).empty?
        case1 || case2
      end
    
      def self.find_invitation(id1, id2)
        if Friendship.where(user_id: id1, friend_id: id2, confirmed: true).empty?
            Friendship.where(user_id: id2, friend_id: id1, confirmed: true)[0].id
        else
            Friendship.where(user_id: id1, friend_id: id2, confirmed: true)[0].id
        end
      end
end
