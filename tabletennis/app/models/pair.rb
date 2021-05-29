class Pair < ApplicationRecord
    belongs_to :player1, class_name: :User
    belongs_to :player2, class_name: :User
    belongs_to :tournament, class_name: :Tournament
    belongs_to :game, class_name: :Game, optional: true
end
