class AddAmazonIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :spree_products, :amazon_id, :string
    add_index :spree_products, :amazon_id
  end

  def self.down
    remove_column :spree_products, :amazon_id
  end
end
