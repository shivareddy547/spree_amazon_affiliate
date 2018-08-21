Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "amazon_admin_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= tab :amazon_taxons, :label => t(:amazon), :match_path => '/amazon' %>")
