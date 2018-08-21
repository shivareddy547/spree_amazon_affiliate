# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_amazon_affiliate'
  s.version     = '1.0.0.beta'
  s.summary     = 'The Amazon Affiliate extension for Spree allows the import of Amazon products into your store, and will link to Amazon rather than the cart.'
  s.description = 'The Amazon Affiliate extension for Spree allows the import of Amazon products into your store, and will link to Amazon rather than the cart.'
  s.required_ruby_version = '>= 2.1.0'

  s.author            = 'Jeff Dutil'
  s.email             = 'JDutil@BurlingtonWebApps.com'
  s.homepage          = 'http://jdutil.com/jdutil/spree_amazon_affiliate'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'amazon-ecs'
  s.add_dependency 'htmlentities'
  s.add_dependency 'json'
  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'

  s.add_development_dependency 'capybara',     '~> 1.1'
  s.add_development_dependency 'factory_girl', '~> 2.6'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'simplecov',    '~> 0.6.2'
  s.add_development_dependency 'sqlite3',      '~> 1.3.6'
  s.add_development_dependency 'protected_attributes'

  # s.add_dependency 'base64'

end
