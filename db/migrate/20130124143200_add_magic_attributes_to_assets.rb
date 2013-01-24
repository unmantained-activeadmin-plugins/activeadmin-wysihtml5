class AddMagicAttributesToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :storage_width, :integer
    add_column :assets, :storage_height, :integer
    add_column :assets, :storage_aspect_ratio, :float
    add_column :assets, :storage_depth, :integer
    add_column :assets, :storage_format, :string
    add_column :assets, :storage_mime_type, :string
    add_column :assets, :storage_size, :string
  end
end
