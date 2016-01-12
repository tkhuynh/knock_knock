class Meeting < ActiveRecord::Base
	validate :end_cannot_be_earlier_than_start_and_must_be_within_a_day

	belongs_to :ta
	belongs_to :student

	validates :subject, presence: true, length: { in: 2..100 }
  validates :start_time, presence: true
  validates :end_time, presence: true

private

  def end_cannot_be_earlier_than_start_and_must_be_within_a_day
    unless start_time > Time.now && end_time > start_time && end_time < start_time.end_of_day
  		time_error
  	end
  end

  def time_error
    errors.add(:time_error, ": end time must greater then start time and within a day.")
  end

end
