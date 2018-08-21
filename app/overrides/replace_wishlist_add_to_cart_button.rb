# if Rails.application.railties.all.map(&:railtie_name).include? "spree_wishlist"

  Deface::Override.new(:virtual_path => "spree/wishlists/show",
                       :name => "replace_wishlist_add_to_cart_button",
                       :replace => "code[erb-loud]:contains('populate_orders_url')",
                       :closing_selector => "code[erb-silent]:contains('end')",
                       :partial => %q{spree/wishlists/add_to_cart_button})

# end
