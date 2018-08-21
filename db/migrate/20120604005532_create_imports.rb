class CreateImports < ActiveRecord::Migration
  def change
    create_table :spree_amazon_imports do |t|
      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.string :attachment_content_type
      t.datetime :attachment_updated_at
      t.timestamps
    end
  end
end
