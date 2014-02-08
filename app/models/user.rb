require 'bcrypt'

  class User < ActiveRecord::Base
    # users.password_hash in the database is a :string
    include BCrypt

    has_many :posts

    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
    end

    def self.authenticate(email, password)
      user = User.find_by_email(email)
      return user if user && (user.password == password)
      nil # either invalid email or wrong password
    end

  end
