class StartTourJob < ApplicationJob
  queue_as :default

  def perform(tour)
    tour.status = 1
    tour.save!
    if (tour.status == 1)
      if (tour.count == tour.tournament_members.count)
        tour.create_pairs
        RoundJob.perform_later(0)
      end
    end
  end
end
