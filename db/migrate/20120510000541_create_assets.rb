class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :storage_uid
      t.string :storage_name
      t.string :type
      t.timestamps
    end
  end
end
