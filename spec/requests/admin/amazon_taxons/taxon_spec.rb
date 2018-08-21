require 'spec_helper'

describe 'Admin - Amazon Taxons' do

  before do
    visit spree.admin_path
    within 'div#admin-menu' do
      click_link "Amazon"
    end
    within 'div#sub-menu' do
      click_link "Taxons"
    end
  end

  it "should display the taxon index and navigate to child taxons properly" do
    page.should have_content(Spree::Amazon::Taxon.roots.first.name)
    click_link 'Child Taxons'
    page.should have_content(Spree::Amazon::Taxon.roots.first.children.first.name)
  end

end
