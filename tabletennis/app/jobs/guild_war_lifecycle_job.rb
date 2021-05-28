class GuildWarLifecycleJob < ApplicationJob
  queue_as :default

  def perform(war)
    war.update(status: "ended")
    # war.destroy
  end
end
