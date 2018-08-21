namespace :spree_amazon_affiliate do

  desc 'Update Amazon Products'
  task :update_products => :environment do
    Spree::Product.where('amazon_id IS NOT NULL').each_with_index do |product, idx|
      Spree::Amazon::Product.find_and_save_to_spree(product.amazon_id)
      puts "#{idx+1} Done."
    end
  end

end
