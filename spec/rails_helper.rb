# frozen_string_literal: true

ENV["RAILS_ENV"] = 'test'

require 'spec_helper'
require 'factory_bot_rails'
# require 'faker'
require 'rails'

require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
end
