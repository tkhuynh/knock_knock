class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :meetings, :start, :start_time
  	rename_column :meetings, :end, :end_time
  end
end
