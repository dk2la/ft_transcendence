class GuildWarLifecycleJob < ApplicationJob
  queue_as :default

  def perform(war, flag)
    p "IN JOB"
    p flag
    if flag == 0
      war.update(status: "confirmed")
    elsif flag == 1
      war.update(status: "ended")
    end
    # war.destroy
  end
end
