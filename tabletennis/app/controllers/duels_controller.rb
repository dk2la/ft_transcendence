class DuelsController < ApplicationController
    def create
        id1 = params[:ids][:id1]
        id2 = params[:ids][:id2]
        p id1
        p id2
        @duel = Duel.new(sender_id: id1, receiver_id: id2)
        if @duel.save
            game = Game.new(name: ('a'..'z').to_a.shuffle[0..7].join, player1: User.find_by(id: id1), name_player1: User.find_by(id: id1).nickname, gametype: "ladder")
            if game.save
              redirect_to game, notice: "Waiting duel opponent #{User.find_by(id: id2).nickname}"
            else
              redirect_to list_profiles, alert: "Game doesnt create, #{game.errors.full_message.join('; ')}"
            end
        else
            redirect_to games_path, alert: "Hm, #{@duel.errors.full_message.join('; ')}"
        end
      end
    
      def destroy
        duel = Duel.find(params[:duel_id])
        duel.destroy
        redirect_to games_path(current_user.id), alert: "Reject duel"
      end
    
      def update
        duel = Duel.find(params[:duel_id])
        p current_user
        duel.update(confirmed: true)
        game = Game.find_by(player1: duel.sender_id, is_finished: false)
        game.update(player2: current_user, name_player2: current_user.nickname)
        game.mysetup
        game.save
        redirect_to game, notice: "Let`s play kids"
      end
end
