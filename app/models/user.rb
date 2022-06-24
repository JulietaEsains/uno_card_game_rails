class User < ApplicationRecord
    require "securerandom"

    has_secure_password

    has_many :games 

    validates :name, presence: true
    validates :email, presence: true
    validates :username, presence: true, uniqueness: true
end