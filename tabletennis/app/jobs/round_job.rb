class RoundJob < ApplicationJob
  queue_as :default

  def perform(round_id)
    games = Tournament.last.pairs.where(round: round_id)
    if round_id + 1 >= 0
      games.each do |g|
        ga = Game.create(name: ('a'..'z').to_a.shuffle[0..7].join, gametype: "ladder", player1: g.player1, player2: g.player2)
        ga.mysetup
        ga.save
        EndTourJob.set(wait: 1.minutes).perform_later(Tournament.last)
      end
    else
      games.each do |g|
        ga = Game.create(name: ('a'..'z').to_a.shuffle[0..7].join, gametype: "ladder", player1: g.player1, player2: g.player2)
        ga.mysetup
        ga.save
        RoundJob.set(wait: 2.minutes).perform_later(round_id + 1)
      end
    end
  end
end
