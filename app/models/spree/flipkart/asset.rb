module Spree
  module Flipkart
    class Asset < Spree::Flipkart::Base
      attr_accessor :url

      def url(style = :product)
        @url[style.to_sym]
      end

      def initialize(_url)
        @url = _url
      end
    end
  end
end
