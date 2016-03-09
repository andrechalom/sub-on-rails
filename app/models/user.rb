class User < ActiveRecord::Base
    USER_REGEX = /\A[A-Z0-9._-]+\z/i
    validates :login, presence: true, uniqueness: true, length: { minimum: 3 }, format: USER_REGEX
    EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
    validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX
    has_secure_password

    def authorized
        return ! user_id.nil?
    end
end
