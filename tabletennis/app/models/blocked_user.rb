class BlockedUser < ApplicationRecord
    belongs_to :user
    belongs_to :cur, class_name: :User
end
