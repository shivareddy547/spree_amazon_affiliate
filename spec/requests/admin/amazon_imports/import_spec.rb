require 'spec_helper'

describe 'Admin - Amazon Imports' do

  before do
    visit spree.admin_path
    within 'div#admin-menu' do
      click_link "Amazon"
    end
    within 'div#sub-menu' do
      click_link "Imports"
    end
  end

  it "should display the download template link and allow downloading the template" do
    page.should have_content('Download Template')
    click_link 'Download Template'
  end

  it 'should display errors when invalid spreadsheet entries' do
    pending 'Need to implement a import validation.'
    Spree::Product.find_by_amazon_id('067001835X').should be_nil
    attach_file 'upload_file', File.join(File.expand_path('../../../../fixtures/invalid_template.csv', __FILE__))
    click_button 'Upload'
    page.should have_content('1 row could not be processed')
    Spree::Product.find_by_amazon_id('067001835X').should be_nil
  end

  it 'should create products from valid import file' do
    Spree::Product.find_by_amazon_id('067001835X').should be_nil
    attach_file 'upload_file', File.join(File.expand_path('../../../../fixtures/valid_template.csv', __FILE__))
    click_button 'Upload'
    page.should have_content('Upload Complete')
    Spree::Product.find_by_amazon_id('067001835X').taxons.should include(Spree::Taxon.find_by_name('Amazon'))
  end

end
