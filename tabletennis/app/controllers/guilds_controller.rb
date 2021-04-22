class GuildsController < ApplicationController
  def index
    @guilds = Guild.all
  end
end
