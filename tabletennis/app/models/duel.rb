class Duel < ApplicationRecord
    belongs_to :sender, class_name: :User
    belongs_to :receiver, class_name: :User

    def self.reacted?(id1, id2)
        case1 = !Duel.where(sender_id: id1, receiver_id: id2).empty?
        case2 = !Duel.where(sender_id: id2, receiver_id: id1).empty?
        case1 || case2
      end
    
      def self.confirmed_record?(id1, id2)
        case1 = !Duel.where(sender_id: id1, receiver_id: id2, confirmed: true).empty?
        case2 = !Duel.where(sender_id: id2, receiver_id: id1, confirmed: true).empty?
        case1 || case2
      end
    
      def self.find_invitation(id1, id2)
        if Duel.where(sender_id: id1, receiver_id: id2, confirmed: true).empty?
            Duel.where(sender_id: id2, receiver_id: id1, confirmed: true)[0].id
        else
            Duel.where(sender_id: id1, receiver_id: id2, confirmed: true)[0].id
        end
      end
end
