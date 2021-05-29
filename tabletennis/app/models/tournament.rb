class Tournament < ApplicationRecord
    has_many :tournament_members, class_name: :TournamentMember
    has_many :pairs, class_name: :Pair

    # NAME_VALIDATE_REGEX = /[a-zA-Z ]/

    # validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 5, maximum: 15}, uniqueness: true
    # validates :count, numericality: { only_integer: :odd }
    # prize
    # sale
    # date start
    # date end


    def create_pairs
        p "SALAM"
        players = self.tournament_members
        p "SALAM1 #{players[0]}"
        rounds = players.count - 1
        matches = players.count / 2
        rounds.times do |i|
            p "SALAM2"
            matches.times do |j|
                p "SALAM3"
                self.pairs.create    player1: players[j].player,
                                    player2: players.reverse[j].player,
                                    round: i
            end
            players = [players[0]] + players[1..-1].rotate(-1)
        end
    end
end