module Spree
  module Flipkart
    class Image < Spree::Flipkart::Base

      attr_accessor :alt, :attachment

      def initialize(url, _alt = nil)
        @attachment = Spree::Amazon::Asset.new(url)
        @alt = _alt.to_s
      end

    end
  end
end
