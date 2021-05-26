class GuildWarLifecycleJob < ApplicationJob
  queue_as :default

  def perform(war)
    war.update(status: "ended")
    p "END OF WAR\n\n\n\n\n\n"
  end


end
