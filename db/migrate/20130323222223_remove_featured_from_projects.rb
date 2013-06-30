class RemoveFeaturedFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :featured
  end
 
  def down
    add_column :users, :featured, :boolean
  end
end
