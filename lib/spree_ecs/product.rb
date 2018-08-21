module SpreeEcs
  class Product < SpreeEcs::Base

    class << self

      # Search products
      #
      def search(options={})
        @query = options.delete(:q)
        # @options = Spree::Config.amazon_options[:query][:options].merge(options)
        @options = SpreeAmazonAffiliate::Engine.amazon_options[:query][:options].merge(options)
        # You cannot use Sort option if searching the All index: 
        # http://docs.amazonwebservices.com/AWSECommerceService/2011-08-01/DG/index.html?CommonItemSearchParameters.html#BlendedSearches
        @options.delete(:sort) if @options[:search_index] == 'All'
        # If searching with BrowseNode can't set SearchIndex as All
        @options.delete(:search_index) if @options[:browse_node] && @options[:search_index] == 'All'
        # Inserts query setting when user configuration appends to all queries.
        # @query = Spree::Config.amazon_options[:query][:q].to_s.gsub("%{q}", @query)
        @query = SpreeAmazonAffiliate::Engine.amazon_options[:query][:q].to_s.gsub("%{q}", @query)

        cache("spree_ecs:product:search:#{@query}:#{@options.stringify_keys.sort}") {
          log "spree_ecs:product:search: #{@query}; @options #{@options.inspect}"
          @response = Amazon::Ecs.item_search(@query, @options)
          {
            :current_page  => (@response.item_page.to_i == 0 ? 1 : @response.item_page.to_i),
            :num_pages     => @response.total_pages,
            :products      => @response.items.map{ |item| mapped(item) },
            :total_entries => @response.total_results
          }
        }


      end

      def search_save_flipkart(query,options,products)
    @query=query
    @options=options
    @products=products

        @query = SpreeAmazonAffiliate::Engine.amazon_options[:query][:q].to_s.gsub("%{q}", @query)
        p "=====================fdgfdgfdgfdgfdgdgdfg=dfgdfgdfgfdgfd"
        p products
        cache("spree_ecs:product:search:#{@query}:#{@options.stringify_keys.sort}") {
          log "spree_ecs:product:search: #{@query}; @options #{@options.inspect}"
          @response = Amazon::Ecs.item_search(@query, @options)
          {
              :current_page  => 1,
              :num_pages     => 27475,
              :products      => products,
              :total_entries => 274743
          }
        }
      end


      # Find product by asin
      #
      def find(asin, options={})
        cache("spree_ecs:product:find:#{asin}:#{options.stringify_keys.sort}") do
          log("spree_ecs:product:find: asin: #{asin}; options: #{options.inspect}")
          mapped(Amazon::Ecs.item_lookup(asin, {:response_group => "Large, Accessories"}.merge(options)).items.first)
        end
      end

      # MultiFind product by asin
      #
      def multi_find(asins, options={})
        cache("spree_ecs:product:multifind:#{asins}:#{options.stringify_keys.sort}") do
          log("spree_ecs:product:multifind: asin: #{asins}; options: #{options.inspect}")
          Amazon::Ecs.item_lookup(asins, {:response_group => "Large, Accessories"}.merge(options)).items.map{ |v| mapped(v) }
        end
      end

      private

      def mapped(item)
        p "===================maped=============="
        log "MAPPED: #{item}"
        return {} if item.nil?
        {
          :description        => item.get('EditorialReviews/EditorialReview/Content'),
          :id                 => item.get('ASIN'),
          :images             => parse_images(item),
          :name               => item.get('ItemAttributes/Title'),
          :price              => (item.get('ItemAttributes/ListPrice/Amount').to_s[0..-3].to_i rescue 0),
          :low_price          => (item.get('OfferSummary/LowestNewPrice/Amount').to_s[0..-3].to_i rescue 0),
          :currency           => item.get('ItemAttributes/ListPrice/CurrencyCode'),
          :taxons             => parse_taxons(item),
          :url                => item.get('DetailPageURL'),
          :variants           => parse_variants(item),
          :variant_attributes => parse_variant_attributes(item),
          :variant_options    => parse_variant_options(item)

        }
      end

      def parse_taxons(item)
        @_taxons = []
        item.get_elements("Ancestors").each{|x|
          @node_name  = (x/"BrowseNode").at("Name").text
          @node_id    = (x/"BrowseNode").at("BrowseNodeId/").text
          if !@node_name.blank? &&
              @node_name !~ /products|categories|features/i &&
              !@_taxons.map{|v| v[:id] }.include?(@node_id)
            @_taxons << { :name => @node_name, :id => @node_id, :search_index => "Books"  }
          end
        }
        @_taxons
      rescue
        []
      end

      def parse_images(item)
        images = []
        image_sets = item.get_elements("ImageSets/ImageSet")
        if image_sets.present?
          image_sets.each do |image_set|
            images << {
              :mini    => image_set.get('SmallImage/URL'),
              :small   => image_set.get('SmallImage/URL'),
              :product => image_set.get('MediumImage/URL'),
              :large   => image_set.get('LargeImage/URL')
            }
          end
        end
        return images
      end

      def parse_variants(item)
        if item.get("Variations/TotalVariations").to_i  > 0
          item.get_elements("Variations/Item").map{ |v| mapped(v) }
        else
          []
        end
      end

      def parse_variant_options(item)
        item.get_elements("VariationAttributes/VariationAttribute").map(&:get_hash)
      rescue
        [ ]
      end

      def parse_variant_attributes(item)
        item.get_element("ItemAttributes").get_hash
      rescue
        []
      end

    end # end class << self

  end
end
