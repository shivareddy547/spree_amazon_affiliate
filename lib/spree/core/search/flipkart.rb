module Spree
  module Core
    module Search

      class Flipkart < Spree::Core::Search::Base

        def prepare(params)
          @properties[:keywords] = params[:keywords]
          @properties[:page]     = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
          @properties[:per_page] = Spree::Config[:products_per_page]
          @properties[:taxon]    = params[:taxon_id].blank? ? nil : Spree::Amazon::Taxon.find(params[:taxon_id])
        end

        def retrieve_products
          options   = {:item_page => page}
          # Set search query
          options.merge!({:q => keywords}) if keywords
          # Set Taxon options if searching a particular Taxon
          # options.merge!({ :browse_node => taxon.id, :search_index => taxon.search_index }) if taxon.present?
          # Spree::Flipkart::Product.search(options)
          #
          p "================ops========================="
          p options
        end

      end

    end
  end
end
