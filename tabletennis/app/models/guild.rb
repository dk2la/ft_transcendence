class Guild < ApplicationRecord
    has_many :guild_members
    has_many :users, :through => :guild_members

    ANAGRAM_VALIDATE_REGEX = /[A-Z]/
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
    validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 5, maximum: 15}, uniqueness: true
    validates :anagram, presence: true, format: { with: ANAGRAM_VALIDATE_REGEX }, length: {minimum: 4, maximum: 5}, uniqueness: true
    validates :description, presence: true, length: {minimum: 3, maximum: 300}
end
