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

def stub_freesound_harvest_requests(extraction_definition)
  (1..4).each do |page|
    stub_request(:get, extraction_definition.base_url).with(
      query: { 'page' => page, extraction_definition.per_page_parameter => extraction_definition.per_page }
    ).to_return(fake_response("freesound_#{page}"))
  end
end

def stub_trove_harvest_requests(extraction_definition, pages_and_tokens)
  pages_and_tokens.each do |page, token|
    stub_request(:get, extraction_definition.base_url).with(
      query: { 
        'page' => page, 
        extraction_definition.per_page_parameter => extraction_definition.per_page,
        extraction_definition.token_parameter => token
      },
      headers: fake_json_headers
    ).to_return(fake_response("trove_#{page}"))
  end
end

def stub_inaturalist_harvest_requests(extraction_definition, pages_and_tokens)
  pages_and_tokens.each do |page, token|
    stub_request(:get, extraction_definition.base_url).with(
      query: { 
        'page' => page, 
        extraction_definition.per_page_parameter => extraction_definition.per_page,
        extraction_definition.token_parameter => token
      },
      headers: fake_json_headers
    ).to_return(fake_response("inaturalist_#{page}"))
  end
end

