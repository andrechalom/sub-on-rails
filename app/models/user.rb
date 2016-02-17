class User < ActiveRecord::Base
    has_secure_password

    validates :login, presence: true, uniqueness: true, length: { minimum: 3 }
    EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
    validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX

end
