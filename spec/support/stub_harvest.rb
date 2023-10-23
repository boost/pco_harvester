# frozen_string_literal: true

def stub_figshare_harvest_requests(request)
  (1..5).each do |page|
    stub_request(:get, request.url).with(
      query: {
        'page' => page,
        'itemsPerPage' => 10,
        'search_for' => 'zealand'
      },
      headers: fake_json_headers
    ).to_return(fake_response("figshare_#{page}"))
  end

  # Stub the last page as a duplicate so the harvest finishes
  stub_request(:get, request.url).with(
    query: {
      'page' => 6,
      'itemsPerPage' => 10,
      'search_for' => 'zealand'
    },
    headers: fake_json_headers
  ).to_return(fake_response('figshare_5'))
end

def stub_failed_figshare_harvest_requests(request)
  (1..5).each do |page|
    stub_request(:get, request.url).with(
      query: {
        'page' => page,
        'itemsPerPage' => request.parameters.find { |parameter| parameter.name == 'itemsPerPage' }.content,
        'search_for' => 'zealand'
      },
      headers: fake_json_headers
    ).to_return(fake_response("failed_figshare_#{page}"))
  end
end

def stub_freesound_harvest_requests(request)
  (1..4).each do |page|
    stub_request(:get, request.url).with(
      query: { 'page' => page, 'page_size' => '50' }
    ).to_return(fake_response("freesound_#{page}"))
  end

  # Stub the last page with a duplicate so that the harvest finishes
  stub_request(:get, request.url).with(
    query: { 'page' => 5, 'page_size' => '50' }
  ).to_return(fake_response('freesound_4'))
end

def stub_trove_harvest_requests(request, pages_and_tokens)
  pages_and_tokens.each do |page, token|
    stub_request(:get, request.url).with(
      query: {
        'n' => '100',
        's' => token
      },
      headers: fake_json_headers
    ).to_return(fake_response("trove_#{page}"))
  end
end

def stub_inaturalist_harvest_requests(extraction_definition, pages_and_tokens)
  pages_and_tokens.each do |page, token|
    stub_request(:get, extraction_definition.base_url).with(
      query: {
        'per_page' => 30,
        'id_above' => token
      },
      headers: fake_json_headers
    ).to_return(fake_response("inaturalist_#{page}"))
  end

  # Stub the last page as a duplicate so the harvest finishes
  stub_request(:get, extraction_definition.base_url).with(
    query: {
      'per_page' => 30,
      'id_above' => '11267278'
    },
    headers: fake_json_headers
  ).to_return(fake_response('inaturalist_4'))
end
