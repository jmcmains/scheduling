class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :featured, default: true

      t.timestamps
    end
  end
end
