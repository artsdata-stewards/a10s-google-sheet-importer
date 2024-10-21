#!/usr/bin/env ruby
require 'linkeddata'

def A10sPipeline(**args)
  sheet_url = args[:sheet_url]
  artifact = args[:artifact]
 
  # url = "https://docs.google.com/spreadsheets/d/1d_dZAPjEsBGLGvskRVkunZU9pmWcHdMyGXoR3-9a2Z8/export?format=csv&gid=2032887030"
  graph = RDF::Graph.load(sheet_url)

  solutions = graph.query([nil, RDF::URI.new("#{sheet_url}#jsonld"), nil])
  jsonld = []
  solutions.each do |solution|
    jsonld << JSON.parse(solution.object)
  end
  
  File.open("./artifacts/#{artifact}.json", 'w') do |file|
    file.puts(jsonld.to_json)
  end
end



# Check if a parameter is provided
if ARGV.length == 0
  puts "Usage: ruby main.rb <sheet_url> <artifact>"
  exit
end

sheet_url = ARGV[0]
artifact = ARGV[1]

A10sPipeline(sheet_url: sheet_url, artifact: artifact)
