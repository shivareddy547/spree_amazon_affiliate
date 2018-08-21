require 'csv'
require 'open-uri'
require 'openssl'
# TODO FIX THIS HACK
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Spree
  module Amazon
    class Import < ActiveRecord::Base
      set_table_name 'spree_amazon_imports'

      attr_accessible :attachment
      validates_attachment_presence :attachment
      has_attached_file :attachment,
                        :url => '/:class/:id/:style/:basename.:extension',
                        :path => ':rails_root/public/:class/:id/:style/:basename.:extension'

      # Load user defined paperclip settings
      if Spree::Config[:use_s3]
        s3_creds = { :access_key_id => Spree::Config[:s3_access_key], :secret_access_key => Spree::Config[:s3_secret], :bucket => Spree::Config[:s3_bucket] }
        self.attachment_definitions[:attachment][:storage]        = :s3
        self.attachment_definitions[:attachment][:s3_credentials] = s3_creds
        self.attachment_definitions[:attachment][:s3_permissions] = :private
      end

      self.attachment_definitions[:attachment][:path]          = Spree::Config[:attachment_path]
      self.attachment_definitions[:attachment][:default_url]   = Spree::Config[:attachment_default_url]


      def self.run file_path, options = {}
        if file_path =~ /http/
          CSV.foreach(open(file_path), :headers => true) do |row|
            if product = Spree::Amazon::Product.find_and_save_to_spree(row[0])
              associate_product_with_taxon product, row[1]
              associate_product_with_taxon product, row[2]
            end
          end
          Spree::Amazon::Import.find(options[:import_id]).destroy if options[:import_id].present?
        else
          CSV.foreach(file_path, :headers => true) do |row|
            if product = Spree::Amazon::Product.find_and_save_to_spree(row[0])
              associate_product_with_taxon product, row[1]
              associate_product_with_taxon product, row[2]
            end
          end
        end
      end

      private

      # This method accepts a taxon hierarchy string where each level has a delimeter of: >
      #
      # Example:
      # Categories > Clothing > Men
      # The above example will find or create a taxon tree with Categories as the root and assign the product to the Men's child taxon.
      def self.associate_product_with_taxon(product, taxon_hierarchy)
        return if product.nil? || taxon_hierarchy.nil?
        taxon_hierarchy = taxon_hierarchy.split(/\s*>\s*/)
        # Using find_or_create_by_name is more elegant, but our params code automatically downcases the taxonomy name.
        taxonomy = Spree::Taxonomy.find(:first, :conditions => ["lower(name) = ?", taxon_hierarchy[0].downcase])
        taxonomy = Spree::Taxonomy.create(:name => taxon_hierarchy[0].capitalize) if taxonomy.nil?
        last_taxon = taxonomy.root
        taxon_hierarchy.each_with_index do |taxon,i|
          next if i == 0
          last_taxon = last_taxon.children.find_or_create_by_name_and_taxonomy_id(taxon, taxonomy.id)
        end
        # Spree only needs to know the most detailed taxonomy item
        product.taxons << last_taxon unless product.taxons.include?(last_taxon)
        product.save
      end

    end
  end
end
