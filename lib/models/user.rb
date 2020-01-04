class User < ActiveRecord::Base
    has_many :actions
    has_many :recipients, through: :actions
    has_many :kindacts, through: :actions
end 