class Spree::Admin::AmazonProductsController < Spree::Admin::BaseController

  def create
    if @product = Spree::Amazon::Product.find_and_save_to_spree(params[:asin])
      redirect_to edit_admin_product_path(@product)
    else
      redirect_to admin_amazon_products_path
    end
  end

  def index
    @searcher = Spree::Core::Search::Amazon.new(params)
    p "==============searrararaa================"
    p @searcher
    p "=========================count===="
    p @searcher.retrieve_products.count
    p "-------------------djhdjjdjdjd"
    @amazon_products = @searcher.retrieve_products
  end

end
