#!/usr/bin/env ruby
require 'csv'
require 'set'

['places.tsv', 'pois.tsv', 'connected_components.out'].each { |file| raise "expected #{file}" unless File.exist?(file) }

Place = Struct.new :name, :taxo
places = {}
File.open('places.tsv').each do |line|
  next if line =~ /^id/
  id,name,taxo = line.chomp.split("\t")
  places[id.to_i] = Place.new name, taxo
end

Poi = Struct.new :name, :place
pois = {}
File.open('pois.tsv').each do |line|
  next if line =~ /^poi_id/
  poi_id,name,place_id = line.chomp.split("\t")
  raise "wtF? #{place_id}" unless places[place_id.to_i]
  pois[poi_id.to_i] = Poi.new name, places[place_id.to_i]
end

output = File.open('result.csv','w')
CSV::Writer.generate(output) do |csv|
  csv << ['resemblance','place name','place taxo','#pois','#unique pois','merge link','poi_id','poi_name']
  File.open('connected_components.out').each do |line|
    cols = line.chomp.split("\t")
    resemblance = cols.shift
    poi_ids = cols.map(&:to_i)

    output_row = []
    output_row << resemblance

    place = pois[poi_ids.first].place
    output_row << place.name << place.taxo

    output_row << poi_ids.size

    if poi_ids.size==2
      output_row << "http://atlas.lonelyplanet.com/ui/merge_pois/new?ids[]=#{poi_ids[0]}&ids[]=#{poi_ids[1]}"
    else
      output_row << ''
    end

    unique_names = Set.new
    poi_ids.each do |poi_id|
      name = pois[poi_id].name
      output_row << poi_id << name
      unique_names << name
    end

    output_row.insert(4,unique_names.size)
    
    csv << output_row
  end
end
output.close




