# frozen_string_literal: true

def stub_ngataonga_harvest_requests(extraction_definition)
  (1..3).each do |page|
    stub_request(:get, extraction_definition.base_url).with(
      query: { 'page' => page, 'per_page' => extraction_definition.per_page },
      headers: fake_json_headers
    ).to_return(fake_response("ngataonga_#{page}"))
  end
end

def stub_figshare_harvest_requests(extraction_definition)
  (1..5).each do |page|
    stub_request(:get, extraction_definition.base_url).with(
      query: { 'page' => page, 'itemsPerPage' => extraction_definition.per_page },
      headers: fake_json_headers
    ).to_return(fake_response("figshare_#{page}"))
  end
end

def stub_failed_figshare_harvest_requests(extraction_definition)
  (1..5).each do |page|
    stub_request(:get, extraction_definition.base_url).with(
      query: { 'page' => page, 'itemsPerPage' => extraction_definition.per_page },
      headers: fake_json_headers
    ).to_return(fake_response("failed_figshare_#{page}"))
  end
end

