class Game < ApplicationRecord
    # Validates
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
    validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 5, maximum: 10}, uniqueness: true

    # Relative for players 1 : M
    has_many :game_members
    has_many :users, :through => :game_members
end
