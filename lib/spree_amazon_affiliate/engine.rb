module SpreeAmazonAffiliate
  class Engine < Rails::Engine
    engine_name 'spree_amazon_affiliate'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../../app/overrides/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

      ## SpreeAmazonAffiliate's Customization

      # Spree::Config.class_eval do
      #   class << self
      #     def amazon_options
      #       @@amazon_options ||= if File.exists?(File.join(Rails.root,'config', 'amazon_affiliate.yml'))
      #         YAML.load(File.open(File.join(Rails.root,'config', 'amazon_affiliate.yml')))[Rails.env]
      #       else
      #         # For Install Generator to run we must use config within the gem.
      #         YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config', 'amazon_affiliate.yml')))[Rails.env]
      #       end
      #       @@amazon_options
      #     end
      #   end # end class << self
      # end

      require File.join(File.dirname(__FILE__), "../spree_ecs.rb")

      # Amazon::Ecs.options = {
      #   :associate_tag     => Spree::Config.amazon_options[:configure][:associate_tag],
      #   :AWS_access_key_id => Spree::Config.amazon_options[:configure][:AWS_access_key_id],
      #   :AWS_secret_key    => Spree::Config.amazon_options[:configure][:AWS_secret_key],
      #   :country           => Spree::Config.amazon_options[:configure][:country],
      #   :response_group    => Spree::Config.amazon_options[:configure][:response_group],
      #   :service           => 'AWSECommerceService',
      #   :Version           => Spree::Config.amazon_options[:configure][:Version]
      # }

      Amazon::Ecs.options = {
        :associate_tag     => SpreeAmazonAffiliate::Engine.amazon_options[:configure][:associate_tag],
        :AWS_access_key_id => SpreeAmazonAffiliate::Engine.amazon_options[:configure][:AWS_access_key_id],
        :AWS_secret_key    => SpreeAmazonAffiliate::Engine.amazon_options[:configure][:AWS_secret_key],
        :country           => SpreeAmazonAffiliate::Engine.amazon_options[:configure][:country],
        :response_group    => SpreeAmazonAffiliate::Engine.amazon_options[:configure][:response_group],
        :service           => 'AWSECommerceService',
        :Version           => SpreeAmazonAffiliate::Engine.amazon_options[:configure][:Version]
      }

    end

    def self.amazon_options
      @@amazon_options ||= if File.exists?(File.join(Rails.root,'config', 'amazon_affiliate.yml'))
        YAML.load(File.open(File.join(Rails.root,'config', 'amazon_affiliate.yml')))[Rails.env]
      else
        # For Install Generator to run we must use config within the gem.
        YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config', 'amazon_affiliate.yml')))[Rails.env]
      end
      @@amazon_options
    end

    config.to_prepare &method(:activate).to_proc
  end
end
