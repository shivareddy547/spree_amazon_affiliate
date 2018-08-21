Deface::Override.new(
    virtual_path: 'spree/products/show',
    name: 'add_link_to_mark_product_as_favorite',
    insert_before: "div[id='main-image']",
    text: %Q{
    <%#= render_original %>
    <% if spree_user_signed_in? && spree_current_user.has_favorite_product?(@product.id) %>
<%= link_to '<i class="heart fa fa-heart" style="font-size:48px;color:red"></i>'.html_safe, favorite_product_path(id: @product.id, type: 'Spree::Product'), method: :delete, remote: true, class: 'btn favorite_link',style:"float:right", id: 'unmark-as-favorite' %>
<%#= link_to Spree.t(:unmark_as_favorite), favorite_product_path(id: @product.id, type: 'Spree::Product'), method: :delete, remote: true, class: 'favorite_link btn btn-primary pull-right', id: 'unmark-as-favorite' %>
    <% else %>
<%= link_to '<i class="heart_before fa fa-heart-o" style="font-size:48px;color:red"></i>'.html_safe, favorite_products_path(id: @product.id, type: 'Spree::Product'), method: :post, remote: spree_user_signed_in?, class: 'btn favorite_link',style:"float:right", id: 'mark-as-favorite' %>
<%#= link_to Spree.t(:mark_as_favorite), favorite_products_path(id: @product.id, type: 'Spree::Product'), method: :post, remote: spree_user_signed_in?, class: 'favorite_link btn btn-primary pull-right', id: 'mark-as-favorite' %>
    <% end %>
  }
)
