class Student < User
	has_many :meetings
	has_many :tas, through: :meetings
end