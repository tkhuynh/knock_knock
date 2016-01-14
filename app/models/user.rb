class User < ActiveRecord::Base
	has_secure_password

  belongs_to :course

	has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "https://upload.wikimedia.org/wikipedia/commons/3/37/No_person.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

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

  extend FriendlyId
  friendly_id :name, use: :slugged

end