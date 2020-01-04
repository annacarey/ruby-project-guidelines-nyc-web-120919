class Recipient < ActiveRecord::Base
    has_one :type
    has_many :actions
    has_many :users, through: :actions
    has_many :kindActs, through: :actions
end