require 'base64'
module Spree
  module Amazon
    class Base

      extend ActiveModel::Callbacks
      extend ActiveModel::Naming

      include ActiveModel::AttributeMethods
      include ActiveModel::Conversion
      # include ActiveModel::MassAssignmentSecurity
      include ActiveModel::Serialization
      include ActiveModel::Validations

      def attributes=(attrs={ })
        attrs.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end

      def initialize(*args)
        fields = args.extract_options!
        fields.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end

      def to_param
        @id.to_s
      end

    end
  end
end
