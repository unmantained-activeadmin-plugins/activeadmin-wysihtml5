class CreateActiveAdminWysihtml5Assets < ActiveRecord::Migration

  def change
    create_table :wysi_html_five_assets do |t|
      t.string :storage_uid
      t.string :storage_name
      t.timestamps
    end
  end

end
