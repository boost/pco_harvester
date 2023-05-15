# frozen_string_literal: true

require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

Sidekiq.configure_client do |config|
  config.logger = Sidekiq::Logger.new(File.open('log/sidekiq-test.log', 'w'))
end
