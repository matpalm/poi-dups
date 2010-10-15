#!/usr/bin/env ruby
require 'csv'
require 'set'

['places.tsv', 'pois.tsv', 'near_dups_v2.out','connected_components.out','false_positives.tsv'].each do |file| 
  raise "expected #{file}" unless File.exist?(file) 
end

# place reference data
# place_id => name taxo
Place = Struct.new :name, :taxo
places = {}
File.open('places.tsv').each do |line|
  next if line =~ /^id/
  id, name, taxo = line.chomp.split("\t")
  places[id] = Place.new name, taxo
end

# poi reference data
# id => name type place_id
Poi = Struct.new :id, :name, :type, :place
pois = {}
File.open('pois.tsv').each do |line|
  next if line =~ /^poi_id/
  poi_id, name, type, place_id = line.chomp.split("\t")
  raise "wtf? unknown place #{place_id}" unless places[place_id]
  pois[poi_id] = Poi.new poi_id, name, type, places[place_id]
end

# connected component info
# poi_id => group
poi_to_group = {}
File.open('connected_components.out').each do |line|
  group, poi_id = line.chomp.split("\t")
  poi_to_group[poi_id] = group
end

# false positives
# [ [poi1_id poi2_id], ... ]
require 'set'
false_positives = Set.new
File.open('false_positives.tsv').each do |line|
  false_positives << line.chomp.split("\t")
end

output = File.open('result.csv','w')
CSV::Writer.generate(output) do |csv|

  csv << ['resemblance','false positive','place name','place taxo','same type','group','merge link',
          'poi1 id','poi1 name','poi1 type','poi2 id','poi2 name','poi2 type']

  File.open('near_dups_v2.out').each do |line|
    cols = line.chomp.split("\t")
    resemblance = cols.shift
    poi1, poi2 = cols.map{ |id| pois[id] }

    output_row = []
    output_row << sprintf("%0.3f", resemblance)

    output_row << false_positives.include?([poi1.id,poi2.id])

    place = poi1.place
    raise "expected to be in same place? #{line}" unless place == poi2.place
    output_row << place.name << place.taxo

    output_row << (poi1.type == poi2.type)

    group = poi_to_group[poi1.id]
    raise "expected pois to be in same connected component group" unless group == poi_to_group[poi2.id]
    output_row << group
    
    output_row << "http://atlas.lonelyplanet.com/ui/merge_pois/new?ids[]=#{poi1.id}&ids[]=#{poi2.id}"
    
    output_row << poi1.id << poi1.name << poi1.type
    output_row << poi2.id << poi2.name << poi2.type

    csv << output_row
  end
end
output.close




