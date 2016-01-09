class Ta < User
	has_many :meetings, dependent: :destroy
	has_many :students, through: :meetings
end