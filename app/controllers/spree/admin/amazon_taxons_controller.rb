class Spree::Admin::AmazonTaxonsController < Spree::Admin::BaseController

  def index
    if params[:taxon_id]
      @taxons = Spree::Amazon::Taxon.find(params[:taxon_id]).children
    else
      @taxons = Spree::Amazon::Taxon.roots
    end
  end

end
