class KindAct < ActiveRecord::Base
    has_many :actions
    has_many :users, through: :actions
    has_many :recipients, through: :actions
end