class Spree::Admin::FlipkartProductsController < Spree::Admin::BaseController

  def create
    if @product = Spree::Flipkart::Product.find_and_save_to_spree(params[:asin],params[:cache_pams])
      redirect_to edit_admin_product_path(@product)
    else
      redirect_to admin_amazon_products_path
    end
  end

  def index
    @searcher = Spree::Core::Search::Flipkart.new(params)
    p "==============searrararaa================"
    p @searcher
    p "=========================count===="
    p @searcher.retrieve_products.count
    p "-------------------djhdjjdjdjd"
    @amazon_products = @searcher.retrieve_products
  end

  def search_products
    # @searcher = Spree::Core::Search::Flipkart.new(params)
    # p "==============searrararaa================"
    # p @searcher
    # p "=========================count===="
    # p @searcher.retrieve_products.count
    # p "-------------------djhdjjdjdjd"
    # @amazon_products = @searcher.retrieve_products
    #
    # fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.1.0")
    # @categories = fk_api.get_categories(json)
    @flipkart_products,@cache = Spree::Flipkart::Product.search_prod(params["keywords"])

  end

  def flipkart_products
    fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.1.0")
    @categories = fk_api.get_categories(json)
    #
    # @searcher = Spree::Core::Search::Amazon.new(params)
    # p "==============searrararaa================"
    # p @searcher
    # p "=========================count===="
    # p @searcher.retrieve_products.count
    # p "-------------------djhdjjdjdjd"
    # @amazon_products = @searcher.retrieve_products

  end

end
