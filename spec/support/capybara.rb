# frozen_string_literal: true

require 'capybara/rails'
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, js: true, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
