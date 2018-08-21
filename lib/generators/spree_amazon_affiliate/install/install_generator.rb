module SpreeAmazonAffiliate
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def add_javascripts
        append_file "app/assets/javascripts/store/all.js", "//= require store/spree_amazon_affiliate\n"
        append_file "app/assets/javascripts/admin/all.js", "//= require admin/spree_amazon_affiliate\n"
      end

      def add_stylesheets
        inject_into_file "app/assets/stylesheets/store/all.css", " *= require store/spree_amazon_affiliate\n", :before => /\*\//, :verbose => true
        inject_into_file "app/assets/stylesheets/admin/all.css", " *= require admin/spree_amazon_affiliate\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_amazon_affiliate'
      end

      def run_migrations
         res = ask "Would you like to run the migrations now? [Y/n]"
         if res == "" || res.downcase == "y"
           run 'bundle exec rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end

      def copy_amazon_configuration
        SpreeAmazonAffiliate::Generators::InstallGenerator.source_root(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config'))
        destination = File.join(Rails.root, 'config', 'amazon_affiliate.yml')
        copy_file 'amazon_affiliate.yml', destination
      end
    end
  end
end
