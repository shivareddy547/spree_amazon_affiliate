require 'htmlentities'
require 'open-uri'

module Spree
  module Amazon
    class Product < Spree::Amazon::Base

      include ActionView::Helpers::SanitizeHelper

      attr_accessor :description, :id, :images, :name, :price, :taxons, :variants,:currency,:low_price

      class << self

        # Find product by ASIN
        #
        def find(product_asin)
          new(SpreeEcs::Product.find(product_asin, { :response_group => "Large, Variations" }))
        end

        def find_and_save_to_spree(asin)
          find(asin).try(:save_to_spree)
        end

        def multi_find(asins)
          SpreeEcs::Product.multi_find(asins, { :response_group => "Large, Variations" }).map{ |v| new(v) }
        end

        # Search products
        #
        def search(options={})
          options[:q] ||= '*'
          Rails.logger.debug "SEARCH OPTS #{options.inspect}"
          @results = SpreeEcs::Product.search(options)
          unless @results.blank?
            Spree::Amazon::ProductCollection.build({
                                                    :current_page  => @results[:current_page],
                                                    :products      => @results[:products].map{ |item| new(item) },
                                                    :total_entries => @results[:total_entries],
                                                    :num_pages     => @results[:num_pages],
                                                    :per_page      => 10,
                                                    :search_index  => options[:search_index]
                                                   })
          else
            Spree::Amazon::ProductCollection.build_empty
          end
        end

      end # end class << self

      def has_variants?
        !@variants.blank?
      end

      # Product images
      #
      def images
        @images.blank? ? [] : @images.map{ |x| Spree::Amazon::Image.new(x, @name) }
      end

      def master
        self
      end

      def price
        @price
      end

      # Save amazon product to base or find on amazon id
      #
      def save_to_spree
        p "==============amazon===self=============="
        p self
        p self.low_price.to_f
        p "===================enneneneneen=========="
        ::Spree::Product.save_from_amazon({
                                     :attributes =>{
                                       :available_on     => 1.day.ago,
                                       :description      => coder.decode(self.description),
                                       :meta_description => strip_tags(coder.decode(self.description)).truncate(255),
                                       :meta_title =>   coder.decode(self.name),
                                       :name             => coder.decode(self.name),
                                       :price            => self.price.to_f,
                                       :sku              => self.id,
                                       :cost_price    => self.low_price.to_f
                                     },
                                     :asin          => self.id,
                                     :count_on_hand => 1,
                                     :price         => self.price.to_f,
                                     :cost_currency => self.currency,
                                     :images        => self.images,
                                     :cost_price    => self.low_price.to_f
                                   })
      end

      def taxons
        @taxons.map{ |x| Spree::Amazon::Taxon.find(x[:id]) }
      end

      def variants
        @_variants ||= Spree::Amazon::Variant.build_variants_collection(self, @variants)
        @_variants
      end

      private

      def coder
        @coder ||= HTMLEntities.new
      end

    end
  end
end
