require 'spec_helper'

describe AmazonAffiliateHelper do

  describe '#amazon_affiliate_link' do

    it 'should generate html for affiliate link based on asin and associate tag' do
      amazon_affiliate_link('B0051VVOB2').should eql("<a href=\"http://www.amazon.com/dp/B0051VVOB2?tag=searchburli-20\" class=\"amazon-affiliate-link \" rel=\"nofollow\" target=\"_blank\">Buy on Amazon</a><img alt=\"\" border=\"0\" height=\"1\" src=\"http://www.assoc-amazon.com/e/ir?t=searchburli-20&amp;a=B0051VVOB2\" style=\"border:none !important; margin:0px !important;\" width=\"1\" />")
    end

  end

  describe '#amazon_affiliate_url' do

    it 'should return url based on asin and associate tag' do
      amazon_affiliate_url('B0051VVOB2').should eql('http://www.amazon.com/dp/B0051VVOB2?tag=searchburli-20')
    end

  end

end
