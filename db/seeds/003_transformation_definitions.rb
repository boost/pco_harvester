# frozen_string_literal: true

cp = ContentPartner.first
ed = ExtractionDefinition.first

extraction_job = ExtractionJob.create(
  status: 'completed',
  extraction_definition: ed,
  kind: 'full',
  start_time: DateTime.parse('Mon, 15 May 2023 14:22:25.000000000 NZST +12:00'),
  end_time: DateTime.parse('Mon, 15 May 2023 14:22:54.000000000 NZST +12:00'),
)

transformation_definition = TransformationDefinition.create(
  content_partner: cp,
  extraction_job:,
  name: 'api.ngataonga.org.nz',
  record_selector: '$..results'
)

fields = [
  Field.create(
    name: "content_partner",
    block: "[\"Ngā Taonga Sound & Vision\"]",
    transformation_definition:
  ),
  Field.create(
    name: "display_content_partner",
    block: "[\"Ngā Taonga Sound & Vision\"]",
    transformation_definition:
  ),
  Field.create(
    name: "display_collection",
    block: "[\"Ngā Taonga Sound & Vision\"]",
    transformation_definition:
  ),
  Field.create(
    name: "primary_collection",
    block: "[\"Ngā Taonga Sound & Vision\"]",
    transformation_definition:
  ),
  Field.create(
    name: "collection_title",
    block: "[record['source']]",
    transformation_definition:
  ),
  Field.create(
    name: "title",
    block: "[\n  record['title']\n]",
    transformation_definition:
  ),
  Field.create(
    name: "usage",
    block: "[\"All rights reserved\"]",
    transformation_definition:
  ),
  Field.create(
    name: "copyright",
    block: "[\"All rights reserved\"]",
    transformation_definition:
  ),
  Field.create(
    name: "rights_url",
    block: "[\"https://www.ngataonga.org.nz/about/privacy-and-rights/rights-information\"]",
    transformation_definition:
  ),
  Field.create(
    name: "dc_identifier",
    block: "[record['reference_number']]",
    transformation_definition:
  ),
  Field.create(
    name: "landing_url",
    block: "[\"https://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=\#{record['record_id']}\"]",
    transformation_definition:
  ),
  Field.create(
    name: "internal_identifier",
    block: "[\"http://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=\#{record['record_id']}\"]",
    transformation_definition:
  ),
  Field.create(
    name: "display_date",
    block: "[record['date']]",
    transformation_definition:
  ),
  Field.create(
    name: "date",
    block: "[record['date'].to_date]",
    transformation_definition:
  ),
  Field.create(
    name: "source_id",
    block: "['test']",
    transformation_definition:
  )
]

transformation_definition.update(fields:)
