module Spree
  module Amazon
    class Taxon < Spree::Amazon::Base

      attr_accessor :id, :parent_id, :is_parent, :name, :status, :search_index, :children
      attr_accessor :children, :ancestors
      alias :is_parent? :is_parent

      # ROOT_TAXONS = Spree::Config.amazon_options[:root_taxons].freeze
      ROOT_TAXONS = SpreeAmazonAffiliate::Engine.amazon_options[:root_taxons].freeze

      class << self

        def find(cid)
          new(SpreeEcs::Taxon.find(cid))
        end

        def roots
          @@roots ||= ROOT_TAXONS.map{ |x| find(x[:id]) }
          @@roots
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
