# for test coverage 

ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : "ruby"

if ENV['COVERAGE'] and RUBY_VERSION =~ /^1.9/ and ruby_engine != "jruby"
  require 'simplecov'
  require 'simplecov-rcov'

  class SimpleCov::Formatter::MergedFormatter
    def format(result)
       SimpleCov::Formatter::HTMLFormatter.new.format(result)
       SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start do
    # group coverage data
    add_group "Controllers", "app/controllers"
    add_group "Helpers", "app/helpers"
    add_group "Mailers", "app/mailers"
    add_group "Models", "app/models"
    # exclude from coverage
    add_filter "config/"
    add_filter "features/"
    add_filter "spec/"
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/test/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false 

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end


# Create a Nokogiri document from an XML source, with some whitespace configuration.
def noko_doc(x)
  Nokogiri.XML(x) { |conf| conf.default_xml.noblanks }
end

def mock_user
  mock_user =  mock("user")
  mock_user.stub!(:email)
  mock_user.stub!(:new_record?)
  mock_user.stub!(:is_being_superuser?).and_return(false)
  return mock_user
end

def mock_authed_user
  mock_user =  mock("user")
  mock_user.stub!(:email).and_return("archivist1@example.com")
  mock_user.stub!(:new_record?)
  mock_user.stub!(:is_being_superuser?).and_return(false)
  return mock_user
end

def login_as_archivist1
  login_as "archivist1@example.com", 'beatcal'
end

def login_as(email, password)
  logout

  visit new_user_session_path
  fill_in "Email", :with => email 
  fill_in "Password", :with => password
  click_button "Sign in"
end

def logout
  visit destroy_user_session_path
end
