Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                     :name => "replace_variant_quantity",
                     :replace => "code[erb-loud]:contains('quantity')",
                     :text => '<% unless @product.amazon_id.present? %>
                                 <%= number_field_tag (@product.has_variants? ? :quantity : "variants[#{@product.master.id}]"), 1, :class => "title", :size => 3 %>
                               <% end %>')
