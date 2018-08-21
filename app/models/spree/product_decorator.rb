require 'open-uri'

Spree::Product.class_eval do

  def self.save_from_amazon(options)
    p "======================optionsoptionsoptionsoptions"
    p options
    p 000000000000000000000000000000000000
    p options[:attributes][:price]
    p "========================="
    # binding.pry
    # Find an existing product to update or build a new one.
    if product = find_by_amazon_id(options[:asin])
      product.update_attributes(options[:attributes])    
    else
      product = new(options[:attributes])
      product.amazon_id = options[:asin]
    end
    p "===============productproductproductproductproductproduct========"
    p product
    product.shipping_category_id=1
    product.cost_currency=options[:cost_currency]
    p 111111111111111111111111111111111111111
    p product.save
    p product.errors
    p 444444444444444444444444444444444
    if product.save
      # Update variants
      @master = product.master
      @master.is_master = true # No longer being set now?
      # @master.count_on_hand = options[:count_on_hand]
      p "============price=========="
      p options[:price]
      p "=================================="
      @master.price = options[:price]

      @master.save

      options[:images].map{ |i|
        filename = File.basename(i.attachment.url(:large))
        unless image = @master.images.find_by_attachment_file_name(filename)
          image = @master.images.build
        end
        begin
          # io = open(i.attachment.url(:large))
          # def io.original_filename; File.basename(base_uri.path); end # Hack to make io.original_filename return an actual filename rather than string.io or jibberish.
          # image.attachment = io
          image.attachment = { io: open(i.attachment.url(:large)), filename: filename }
          image.save

        rescue # Rescue 404
        end
      }

    end
    product
  end

  def self.save_from_flipkart(options)
    p "===============flipkart=======optionsoptionsoptionsoptions"
    p options
    p 000000000000000000000000000000000000
    p options[:attributes][:price]
    p "========================="
    # binding.pry
    # Find an existing product to update or build a new one.
    if product = find_by_amazon_id(options[:asin])
      product.update_attributes(options[:attributes])
    else
      product = new(options[:attributes])
      product.amazon_id = options[:asin]
    end
    p "==========flippppppppp=====productproductproductproductproductproduct========"
    p product
    product.shipping_category_id=1
    product.cost_currency=options[:cost_currency]
    p 111111111111111111111111111111111111111
    p product.save
    p product.errors
    p 444444444444444444444444444444444
    if product.save
      # Update variants
      @master = product.master
      @master.is_master = true # No longer being set now?
      # @master.count_on_hand = options[:count_on_hand]
      p "============price=========="
      p options[:price]
      p "=================================="
      @master.price = options[:price]

      @master.save
      if options[:images].present?
        p "+=========================imagggggggggggggg======"
        p options[:images]
        # options[:images].map{ |i|
        #   p "=======urrrrrrrrrrrrrrrrrrrrrrrrrrrr==========="
        #   # p i.attachment.to_json
        #   p filename = File.basename(JSON.parse(i.attachment.to_json)["url"]["small"])
        #   p @master.images
        #   unless image = @master.images.find_by_attachment_file_name(filename)
        #     image = @master.images.build
        #   end
        #   begin
        #     # io = open(i.attachment.url(:large))
        #     # def io.original_filename; File.basename(base_uri.path); end # Hack to make io.original_filename return an actual filename rather than string.io or jibberish.
        #     # image.attachment = io
        #     p "===========oooooooooooooooooooooooooooo"
        #     p JSON.parse(i.attachment.to_json)["url"]["small"]
        #     image.attachment = { io: open(JSON.parse(i.attachment.to_json)["url"]["small"]), filename: filename }
        #     p "============atatatattatatata==================="
        #     p image.attachment
        #     image.save
        #
        #   rescue # Rescue 404
        #   end
        # }
        options[:images].map{ |i|
          p "=================inside images save================="
          p i.attachment.url(:large)
          p filename = File.basename(i.attachment.url(:large))
          filename=filename.split('.jpeg')
          filename = filename.first+".jpg"+filename.last
          unless image = @master.images.find_by_attachment_file_name(filename)
            image = @master.images.build
          end
          begin
            # io = open(i.attachment.url(:large))
            # def io.original_filename; File.basename(base_uri.path); end # Hack to make io.original_filename return an actual filename rather than string.io or jibberish.
            # image.attachment = io
            p "++++++++++++++++++atatatattatatatatatattatatatatataa====================="
            p filename
            image.attachment = { io: open(i.attachment.url(:large)), filename: filename }
            image.save
            p "=================image errororoorror------------"
p image.errors
          rescue # Rescue 404
          end
        }
      end
    end
    product
  end


end
