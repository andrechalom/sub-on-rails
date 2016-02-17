class User < ActiveRecord::Base
    validates :login, presence: true, length: { minimum: 3 }
end
