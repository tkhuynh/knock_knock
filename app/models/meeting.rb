class Meeting < ActiveRecord::Base
	belongs_to :ta
	belongs_to :student
end
