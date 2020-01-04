class Action < ActiveRecord::Base
    belongs_to :user
    belongs_to :kindact
    belongs_to :friend
end