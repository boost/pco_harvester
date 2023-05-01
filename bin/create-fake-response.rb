#!/usr/bin/env ruby

# frozen_string_literal: true

require 'pry'
require 'optparse'
require 'json'
require 'yaml'

def progname
  File.basename($PROGRAM_NAME)
end

options = OpenStruct.new(
  {
    input_filepath: nil,
    data_format: 'json',
    output_filepath: nil,
    output_given: false
  }
)

parser = OptionParser.new do |opts|
  opts.banner = 'USAGE:'
  opts.separator "    #{progname} -f document"
  opts.separator ''
  opts.separator 'OPTIONS:'

  opts.on('-i', '--input FILE', 'document you would like to extract a stub response') do |v|
    options[:input_filepath] = v
  end

  opts.on('-o', '--output FILE', 'stub response file') do |v|
    options[:output_filepath] = v
    options[:output_given] = true
  end

  opts.on('-f', '--format FORMAT', 'data format') do |v|
    options[:data_format] = v
  end

  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit
  end

  opts.separator ''
  opts.separator 'EXAMPLES:'
  opts.separator '    Create a stub response:'
  opts.separator "        Long version #{progname} --input 2023-04-28_03-19-42_-_52/api_ngataonga_org_nz__-__000000001.json --output spec/stub_responses/ngataonga_1.yaml"
  opts.separator "        Short version #{progname} -i 2023-04-28_03-19-42_-_52/api_ngataonga_org_nz__-__000000001.json -o spec/stub_responses/ngataonga_1.yaml"
end

parser.parse!

def usage(parser, error)
  puts "ERROR: #{error}"
  parser.help
  exit 1
end

def clean_up(options)
  return unless File.exist?(options.tmp_path)

  # writing zero to avoid any recovery
  File.write(options.tmp_path, '0' * File.stat(options.tmp_path).size)
  File.delete(options.tmp_path)
end

# get the command options
usage(parser, 'Please specify an input file') if options.input_filepath.nil?
usage(parser, "\"#{options.output_filepath}\" does not exist") if options.output_given && !File.exist?(options.output_filepath)
usage(parser, "\"#{options.input_filepath}\" does not exist") unless File.exist?(options.input_filepath)

if options.output_given && File.exist?(options.output_filepath)
  print 'The output file already exists, do you want to overwrite it (y/n)? '
  response = gets.chomp
  exit 0 if response != 'y'


end

stub_hash = begin
  json = JSON.load_file(options.input_filepath)
  {
    'status' => json['status'],
    'headers' => json['response_headers'],
    'body' => JSON.pretty_generate(JSON.parse(json['body']))
  }
rescue e
  puts "An error occured #{e}"
  exit 1
end

output_io = options.output_given ? File.open(options.output_filepath, 'w') : $stdout
output_io.write(stub_hash.to_yaml)
