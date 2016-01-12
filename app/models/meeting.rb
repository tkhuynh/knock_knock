class Meeting < ActiveRecord::Base
	validate :time_must_be_after_present, :duration_within_the_day

	belongs_to :ta
	belongs_to :student

  validates :start_time, presence: true
  validates :end_time, presence: true

private

  def time_must_be_after_present
    unless start_time > Time.now && end_time > start_time 
  		errors.add(:time_error, ": time must be later than present time.")
  	end
  end

  def duration_within_the_day
    unless end_time < start_time.end_of_day
      errors.add(:time_error, ": time duration must be within a day")
    end  
  end

end
