class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :project_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
