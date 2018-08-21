require 'spec_helper'

describe 'Admin - Amazon Products' do

  before do
    visit spree.admin_path
    within 'div#admin-menu' do
      click_link "Amazon"
    end
    within 'div#sub-menu' do
      click_link "Products"
    end
  end

  it "should be allowed to navigate to by taxons" do
    within 'div#sub-menu' do
      click_link "Taxons"
    end
    click_link "View Products"
    page.should have_css('form.button_to')
  end

  it "should display the parent product index properly" do
    @amazon_products = Spree::Core::Search::Amazon.new({}).retrieve_products
    page.should have_content(@amazon_products.first.name)
  end

  it "should display a taxons product index properly and add a product with the link" do
    visit spree.admin_amazon_products_path(:taxon_id => Spree::Amazon::Taxon.roots.first.id)
    Spree::Product.first.should be_nil
    @amazon_products = Spree::Core::Search::Amazon.new(:taxon_id => Spree::Amazon::Taxon.roots.first.id).retrieve_products
    page.should have_content(@amazon_products.first.name)
    click_button 'Add to store'
    Spree::Product.first.amazon_id.should eql(@amazon_products.first.id)
  end

end
