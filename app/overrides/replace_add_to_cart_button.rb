Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                     :name => "replace_add_to_cart_button",
                     :replace => "code[erb-loud]:contains('add-to-cart-button')",
                     :closing_selector => "code[erb-silent]:contains('end')",
                     :partial => "spree/products/add_to_cart_button")
