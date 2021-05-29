class EndTourJob < ApplicationJob
  queue_as :default

  def perform(tour)
    tour.status = 2
    tour.save!
  end
end
