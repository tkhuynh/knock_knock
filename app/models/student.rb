class Student < User
	has_many :meetings
	has_many :tas, through: :meetings
	belongs_to :course
end