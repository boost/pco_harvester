# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.rm Dir.glob("#{ExtractionJob::EXTRACTIONS_FOLDER}/*/*")
    FileUtils.rmdir Dir.glob("#{ExtractionJob::EXTRACTIONS_FOLDER}/*")
  end
end

def fake_response(filename)
  path = Rails.root.join("spec/stub_responses/#{filename}.yaml")
  YAML.load_file(path)
end

def fake_json_headers
  {
    'Content-Type' => 'application/json',
    'User-Agent' => 'Supplejack Harvester v2.0'
  }
end

def stub_figshare_enrichment_page_1(destination)
  stub_request(:get, "#{destination.url}/harvester/records")
    .with(
      query: {
        'api_key' => 'testkey',
        'search' => {
          'fragments.source_id' => 'test'
        },
        'search_options' => {
          'page' => 1
        }
      },
      headers: fake_json_headers
    ).to_return(fake_response('test_api_records'))

  [23029880, 23029811, 23029790, 23029787, 23029784, 23029733, 23029685, 23029673, 23029661, 23029634, 23072123, 23072120, 23072033, 23071937, 23071886, 23071577, 23071553, 23071328, 23071295, 23071220].each do |article_id|
    stub_request(:get, "https://api.figshare.com/v1/articles/#{article_id}")
      .with(headers: fake_json_headers)
      .to_return(fake_response('figshare_enrichment_1'))
  end
end


def stub_figshare_enrichment_page_2(destination)
    stub_request(:get, "#{destination.url}/harvester/records")
      .with(
        query: {
          'api_key' => 'testkey',
          'search' => {
            'fragments.source_id' => 'test'
          },
          'search_options' => {
            'page' => 2
          }
        },
        headers: fake_json_headers
      ).to_return(fake_response('test_api_records_2'))

  [23071181, 23071178, 23071055, 23070764, 23070638, 23070551, 23070341, 23070317, 23070134, 23069885, 23069813, 23069708, 23069609, 23069582, 23069567, 23069555, 23069426, 23069324, 23069303, 23068361].each do |article_id|
      stub_request(:get, "https://api.figshare.com/v1/articles/#{article_id}")
        .with(headers: fake_json_headers)
        .to_return(fake_response('figshare_enrichment_1'))
  end
end
