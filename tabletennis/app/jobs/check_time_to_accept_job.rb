class CheckTimeToAcceptJob < ApplicationJob
  queue_as :default

  def perform(war)
    kek = count_time
    if kek ==  "finish"
        accept.destroy
        war.guild.accept += 25
        war.count += 1
        war.save!
    end
  end

  def count_time
    # after while
      #check duel object
       # if jbj == true
        return "game_started"
    return "finish"
  end
end
