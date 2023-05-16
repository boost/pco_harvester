# frozen_string_literal: true

cp = ContentPartner.first

ExtractionDefinition.create(
  content_partner: cp,
  name: 'api.ngataonga.org.nz',
  format: 'JSON',
  base_url: 'http://api.ngataonga.org.nz/records.json/?api_key=_yvmC1WsNazhasMgiVkx&and[has_media]=true',
  throttle: 0,
  pagination_type: 'page',
  page_parameter: 'page',
  page: 1,
  per_page_parameter: 'per_page',
  per_page: 100,
  total_selector: '$..result_count'
)
