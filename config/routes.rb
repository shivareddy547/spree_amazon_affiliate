Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :amazon_products, :only => [:create, :index]
    resources :amazon_imports, :only => [:create, :index, :new]
    resources :amazon_taxons, :only => [:index]

    resources :flipkart_products, :only => [:create, :index]
    resources :flipkart_imports, :only => [:create, :index, :new]
    resources :flipkart_taxons, :only => [:index,:flipkart_products]
    get 'flipkart_taxons/flipkart_products'
    get 'flipkart_products/search_products'

  end
  # get "/admin/flipkart_taxons/products_by_taxons","flipkart_taxons#products_by_taxons",:as=>'flipkart_products_by_taxons'

end
