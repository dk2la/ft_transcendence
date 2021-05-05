class Game < ApplicationRecord
    belongs_to :first_user, class_name: 'User'
    belongs_to :second_user, class_name: 'User'

    def users
        [first_user, second_user
    end
end
