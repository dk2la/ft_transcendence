class TournamentsController < ApplicationController
    before_action :authenticate_user!

    def index
        @tournaments = Tournament.all
    end

    def new
        @tournament = Tournament.new
    end

    def create
        p "ALLO"
        p params
        param = params.require(:tournament).permit(:name, :status, :count)
        @tournament = Tournament.new(name: param["name"], status: 0, count: param["count"].to_i)
        if @tournament.save
            redirect_to tournaments_path, notice: "Successfully"
        else
            redirect_to tournaments_path, alert: "#{@tournament.errors.full_message.join('; ')}"
        end
        StartTourJob.set(wait: 1.minute).perform_later(@tournament)
    end

    def join_tour
        @t = Tournament.find(params[:id])
        @t.tournament_members.create(player: current_user)
        redirect_to tournaments_path, notice: "Successfully register to tournament #{@t.name}"
    end

    def unreg
        @t = Tournament.find(params[:id])
        tm = TournamentMember.find_by(player: current_user)
        if tm
            tm.destroy
            redirect_to tournaments_path, notice: "Successfully unreg from tournament #{t.name}"
        else
            redirect_to tournaments_path, alert: "Reg not find"
        end
    end

    def update
    end

    private

    def set_tour
        @tournament = Tournament.find(params[:id])
    end

    def tour_params
        param.require(:tournament).permit(:name, :status, :count)
    end
end
