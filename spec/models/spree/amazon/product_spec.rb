require 'spec_helper'

describe Spree::Amazon::Product do

  context 'ClassMethods' do

    describe 'find_and_save_to_spree' do

      it 'should create a spree product if it does not exist already' do
        spree_prod = subject.class.find_and_save_to_spree('B0051VVOB2')
        spree_prod.should eql(Spree::Product.find_by_amazon_id('B0051VVOB2'))
      end

      it 'should load spree product if it exists' do
        amazon_prod = subject.class.find('B0051VVOB2')
        amazon_prod.save_to_spree
        spree_prod = subject.class.find_and_save_to_spree('B0051VVOB2')
        spree_prod.should eql(Spree::Product.find_by_amazon_id('B0051VVOB2'))
      end

    end

  end

  context 'InstanceMethods' do

    describe '#save_to_spree' do

      before do
        @amazon_prod = subject.class.find('B005CWIVYI')
        @amazon_prod.save_to_spree
        @spree_prod = Spree::Product.find_by_amazon_id('B005CWIVYI')
      end

      it 'should create a spree product with images and a master variant with stock' do
        @spree_prod.images.size.should be > 1
        @spree_prod.master.should be_present
        @spree_prod.master.count_on_hand.should eql(1)
      end

      it 'should encode html entities' do
        amazon_prod = subject.class.find('B006ZLX75S')
        amazon_prod.save_to_spree
        spree_prod = Spree::Product.find_by_amazon_id('B006ZLX75S')
        spree_prod.description.should_not include('&lt;b&gt;')
        spree_prod.description.should include('<b>')
      end

      it 'should strip html from meta_description' do
        amazon_prod = subject.class.find('B006ZLX75S')
        amazon_prod.save_to_spree
        spree_prod = Spree::Product.find_by_amazon_id('B006ZLX75S')
        spree_prod.meta_description.should_not include('<b>')
      end

      it 'should update a spree product that already exists' do
        @spree_prod.master.count_on_hand = 0
        @spree_prod.name = 'Test'
        @spree_prod.save
        @amazon_prod.save_to_spree
        @spree_prod.reload
        @spree_prod.master.count_on_hand.should eql(1)
        @spree_prod.name.should_not eql('Test')
      end

      it 'should not create duplicate images' do
        image_count = @spree_prod.images.size
        @amazon_prod.save_to_spree
        @spree_prod.reload.images.size.should eql(image_count)
      end

    end

  end

end
