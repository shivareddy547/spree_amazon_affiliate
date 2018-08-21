module Spree
  module Flipkart
    class Taxon < Spree::Flipkart::Base

      attr_accessor :id, :parent_id, :is_parent, :name, :status, :search_index, :children
      attr_accessor :children, :ancestors
      alias :is_parent? :is_parent

      # ROOT_TAXONS = Spree::Config.amazon_options[:root_taxons].freeze
      ROOT_TAXONS = SpreeAmazonAffiliate::Engine.amazon_options[:root_taxons].freeze

      class << self

        def find(cid)
          # new(SpreeEcs::Taxon.find(cid))
          p "==========cid======"
          p cid
          fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.0.0")
          products = fk_api.get_products(cid)["products"].each do |pr_each|


          end
          # @results = fk_api.get_products_by_category(cid)
        end

        def roots
          # @@roots ||= ROOT_TAXONS.map{ |x| find(x[:id]) }
          # @@roots
          fk_api = FlipkartApi.new('shivar547', 'f26474f2297943c2a72e91cb91fb3770', "v1.1.0")
          categories = fk_api.get_categories('json')
          if categories.present?
            taxons={}
            tax_a=[]
          JSON.parse(categories)["apiGroups"]["affiliate"]["apiListings"].each do |each_rec|

            tax_a << {:name=> each_rec[0],:taxon_url=>each_rec[1]["availableVariants"]["v1.1.0"]["get"]}

          end

          end
          tax_a
        end

      end # end class << self

      # Products
      #
      def products
        @taxon_products ||= Spree::Amazon::Product.multi_find(SpreeEcs::Taxon.top_sellers(self.id).join(', '))
        @taxon_products
      end

      def permalink
        @id.to_s
      end

      def children
        @_children ||= (@children || []).map{ |v| self.class.new(v) }
        @_children
      end

      def parent
        ancestors.first
      end

      def ancestors
        @_ancestors ||= (@ancestors || []).map{ |v| self.class.new(v) }
        @_ancestors
      end

      def self_and_descendants
        [self, ancestors].flatten.compact
      end

      def applicable_filters
        []
      end

      def root?
        Spree::Amazon::Taxon.roots.find{ |v| v.id.to_s == self.id.to_s }
      end
    end
  end
end
