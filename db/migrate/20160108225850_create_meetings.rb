class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :subject
      t.datetime :start
      t.datetime :end
      t.integer :ta_id
      t.integer :student_id

      t.timestamps null: false

      t.belongs_to :ta
      t.belongs_to :student
    end
  end
end
