require 'htmlentities'
require 'open-uri'
require 'base64'
require 'json'
module Spree
  module Flipkart
    class Product < Spree::Flipkart::Base

      include ActionView::Helpers::SanitizeHelper

      attr_accessor :description, :id, :images, :name, :price, :taxons, :variants,:currency,:low_price,:product_url

      class << self

        # Find product by ASIN
        #
        def find(product_asin,cache)
          p "====product_asinproduct_asinproduct_asinproduct_asinproduct_asin"
          p product_asin
          # new(SpreeEcs::Product.find(product_asin))
          # new(JSON.parse(Base64.decode64(cache)))
        # p  new(Rails.cache.read("#{product_asin}".to_sym))
          Rails.cache.read("#{product_asin}".to_sym)
        end



        def find_tax(cid)
          # new(SpreeEcs::Taxon.find(cid))
          p "==========cid======"
          p cid
          products=[]
          cache = ActiveSupport::Cache::MemoryStore.new
          fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.1.0")
           fk_api.get_products(cid)["products"].each do |pr_each|
            p=Spree::Flipkart::Product.new
            p.id=pr_each["productBaseInfoV1"]["productId"]
            p.images = self.parse_flipkart_images(pr_each)
            p.name = pr_each["productBaseInfoV1"]["title"]
            p.description=pr_each["productBaseInfoV1"]["productDescription"]
            p.price=pr_each["productBaseInfoV1"]["flipkartSellingPrice"]["amount"]
            p.low_price=pr_each["productBaseInfoV1"]["flipkartSellingPrice"]["amount"]
            p.product_url=pr_each["productBaseInfoV1"]["productUrl"]
            p.currency = pr_each["productBaseInfoV1"]["flipkartSellingPrice"]["currency"]
            # p.save
            # cache.write("#{p.id}",p)
            Rails.cache.write("#{p.id}".to_sym, p)
            products << p
          end
          # @results = fk_api.get_products_by_category(cid)
          return products
        end


        def search_prod(query)
          # new(SpreeEcs::Taxon.find(cid))
          p "==========cid======"
          # p cid
          products=[]
          p_encr=""
          # cache = ActiveSupport::Cache::MemoryStore.new
          fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.0.0")
          fk_api.search(query,'json',10)["products"].each do |pr_each|
            p=Spree::Flipkart::Product.new
            p.id= pr_each["productBaseInfoV1"]["productId"]
            p.images = self.parse_flipkart_images(pr_each)
            p.name = pr_each["productBaseInfoV1"]["title"]
            p.price=pr_each["productBaseInfoV1"]["flipkartSellingPrice"]["amount"]
            p.low_price=pr_each["productBaseInfoV1"]["flipkartSellingPrice"]["amount"]
            p.product_url=pr_each["productBaseInfoV1"]["productUrl"]
            p.currency = pr_each["productBaseInfoV1"]["flipkartSellingPrice"]["currency"]
            # p.save
            # cache.write("#{p.id}",p)
            # Base64.encode64('hello world')
            # s = ActiveSupport::JSON.encode(cache)
            # cache.to_json
            p_encr = Base64.encode64(ActiveSupport::JSON.encode(p))
            products << p
            # Rails.cache.read(:foo)
            # p "p.id".to_sym
            Rails.cache.write("#{p.id}".to_sym, p)
            p "+============pppppppppppppppppppp"
            # p p.images.first.attachment.url(:large)
            # p "========jfdsfsffsfsdfs"
            # p ActiveSupport::JSON.encode(p)
          end


          # @results = fk_api.get_products_by_category(cid)

          # @results = SpreeEcs::Product.search(options)
          # unless products.blank?
          #   Spree::Flipkart::ProductCollection.build({
          #                                           :current_page  => 1,
          #                                           :num_pages     => 27475,
          #                                           :products      => products.map{ |item| new(item) },
          #                                           :total_entries => 274743,
          #                                           :per_page      => 12
          #
          #                                          })
          # else
          #   Spree::Flipkart::ProductCollection.build_empty
          # end
          #

          # SpreeEcs::Product.search_save_flipkart(query,options,products)

          return products,p_encr
        end
        # def mapped(item)
        #   log "MAPPED: #{item}"
        #   return {} if item.nil?
        #   {
        #       :description        => item.get('EditorialReviews/EditorialReview/Content'),
        #       :id                 => item.get('ASIN'),
        #       :images             => parse_images(item),
        #       :name               => item.get('ItemAttributes/Title'),
        #       :price              => (item.get('ItemAttributes/ListPrice/Amount').to_s[0..-3].to_i rescue 0),
        #       :low_price          => (item.get('OfferSummary/LowestNewPrice/FormattedPrice').gsub(/\$|,|\ /,'').to_f rescue 0),
        #       :currency           => item.get('ItemAttributes/ListPrice/CurrencyCode'),
        #       :taxons             => parse_taxons(item),
        #       :url                => item.get('DetailPageURL'),
        #       :variants           => parse_variants(item),
        #       :variant_attributes => parse_variant_attributes(item),
        #       :variant_options    => parse_variant_options(item)
        #
        #   }
        # end


        def find_and_save_to_spree(asin,cache)
          p "+++++++++++cachecachecache=============="
          p cache
         p find(asin,cache).try(:save_to_spree)
        end

        def multi_find(asins)
          SpreeEcs::Product.multi_find(asins, { :response_group => "Large, Variations" }).map{ |v| new(v) }
        end

        # Search products
        #
        def search(options={})
          options[:q] ||= '*'
          Rails.logger.debug "SEARCH OPTS #{options.inspect}"
          p "================search opitions =========="
          p options
          fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.1.0")
          @results = fk_api.get_products_by_category()
          # @results = SpreeEcs::Product.search(options)
          # unless @results.blank?
          #   Spree::Amazon::ProductCollection.build({
          #                                           :current_page  => @results[:current_page],
          #                                           :products      => @results[:products].map{ |item| new(item) },
          #                                           :total_entries => @results[:total_entries],
          #                                           :num_pages     => @results[:num_pages],
          #                                           :per_page      => 10,
          #                                           :search_index  => options[:search_index]
          #                                          })
          # else
          #   Spree::Amazon::ProductCollection.build_empty
          # end
        end

      end # end class << self

      def has_variants?
        !@variants.blank?
      end

      # Product images
      #
      def images
        @images.blank? ? [] : @images.map{ |x| Spree::Flipkart::Image.new(x, @name) }
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
        p "============flipkart=====self=============="
        p self.inspect
        p "===================enneneneneen=========="
        ::Spree::Product.save_from_flipkart({
                                     :attributes =>{
                                       :available_on     => 1.day.ago,
                                       :description      => coder.decode(self.description),
                                       :meta_description => strip_tags(coder.decode(self.description)).truncate(255),
                                       :name             => coder.decode(self.name),
                                       :price            => self.price.to_f,
                                       :sku              => self.id
                                     },
                                     :asin          => self.id,
                                     :count_on_hand => 1,
                                     :price         => self.price.to_f,
                                     :cost_currency => self.currency,
                                     :images        => self.images
                                   })
      end

      def taxons
        @taxons.map{ |x| Spree::Amazon::Taxon.find(x[:id]) }
      end

      def variants
        @_variants ||= Spree::Amazon::Variant.build_variants_collection(self, @variants)
        @_variants
      end

      def self.parse_flipkart_images(item)
        images = []
        image_sets = item["productBaseInfoV1"]["imageUrls"]
        if image_sets.present?

          images << {
              :mini    => image_sets["200x200"],
              :small   => image_sets["200x200"],
              :product => image_sets["400x400"],
              :large   => image_sets["800x800"]
          }
          # image_sets.each do |image_set|
          #   images << {
          #       :mini    => image_set["200x200"],
          #       :small   => image_set.get('SmallImage/URL'),
          #       :product => image_set.get('MediumImage/URL'),
          #       :large   => image_set.get('LargeImage/URL')
          #   }
          # end
        end
        return images
      end




      private

      def coder
        @coder ||= HTMLEntities.new
      end

    end
  end
end
