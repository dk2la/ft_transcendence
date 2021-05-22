class Game < ApplicationRecord
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
    validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 5, maximum: 10}, uniqueness: true

    # RELSTIVES FOR PLAYERS
    belongs_to :player1, class_name: :User, required: true
    belongs_to :player2, class_name: :User, required: false

    def view_thread
        20.times {
            p "SALAM JACOCA1 GOD"
            sleep(1) 
        }
    end
end
