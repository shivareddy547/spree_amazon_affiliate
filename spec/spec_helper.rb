# Run Coverage report
unless defined?(Rubinius) or RUBY_VERSION == '1.8.7'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/config/'
    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Overrides', 'app/overrides'
    add_group 'Libraries', 'lib'
    add_group 'Specs', 'spec'
  end
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'ffaker'
require 'rspec/rails'

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Requires factories defined in spree_core
require 'spree/core/testing_support/factories'
require 'spree/core/url_helpers'

RSpec.configure do |config|
  config.include Spree::Core::UrlHelpers

  # Copy over the config file which should really be done by running the extension installer
  config.after(:all) do
    FileUtils.cp File.join(File.dirname(__FILE__), '..', 'config', 'amazon_affiliate.yml'), File.join(Rails.root, 'config', 'amazon_affiliate.yml')
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end
