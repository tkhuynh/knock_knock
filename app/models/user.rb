class User < ActiveRecord::Base
	has_secure_password

	validates :name, presence: true
	validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }
  #only validate passoword and role when signup
  validates :type, presence: true, on: :create
	validates	:password, length: {minimum: 6}, on: :create

end