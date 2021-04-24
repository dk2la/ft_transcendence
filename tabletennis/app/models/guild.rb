class Guild < ApplicationRecord
    validates :name, presence: true, length: {minimum: 5, maximum: 15}, uniqueness: true
    validates :anagram, presence: true, length: {minimum: 4, maximum: 5}, uniqueness: true
    validates :description, presence: true, length: {minimum: 30, maximum: 300}
end
