# frozen_string_literal: true

user_agent = ENV.fetch('SJ_USER_AGENT', 'Supplejack Harvester v2.0')
Faraday.default_connection_options = { headers: { user_agent: } }
