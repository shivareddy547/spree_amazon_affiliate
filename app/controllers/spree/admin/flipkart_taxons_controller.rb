class Spree::Admin::FlipkartTaxonsController < Spree::Admin::BaseController

  def index
    if params[:taxon_id]
      @taxons = Spree::Flipkart::Taxon.find(params[:taxon_id]).children
    else
      @taxons = Spree::Flipkart::Taxon.roots
    end
  end

  def flipkart_products

    if params[:taxon_id]
      p "==========conrtrrrprprprprprp"
     p rest_url = "https://affiliate-api.flipkart.net/affiliate/1.0/feeds/shivar547/category#{params[:taxon_id]}"

      @amazon_products = Spree::Flipkart::Product.find_tax(rest_url)
    end
  end

end
