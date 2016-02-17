class User < ActiveRecord::Base

    validates :login, presence: true, uniqueness: true, length: { minimum: 3 }
    EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
    validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX
    attr_accessor :senha # read only

    # users.senha in the database is a :string
    def password
        @password ||= Password.new(senha)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.senha = @password
    end
end
