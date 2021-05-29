class TournamentMember < ApplicationRecord
    belongs_to :player, class_name: :User
    belongs_to :tournament
end
