#!/usr/bin/env ruby
require 'set'
N_GRAM_LEN = 2

class String

  def shingles
    return @cached if @cached       
    n_grams = Set.new
    (length-N_GRAM_LEN+1).times do |i| 
      n_grams << slice(i, N_GRAM_LEN) 
    end     
    @cached = n_grams
    n_grams
  end

  def jaccard_similarity_to other
    sa = shingles
    sb = other.shingles
    numerator = (sa.intersection sb).size
    denominator = (sa.union sb).size        
    numerator.to_f / denominator  
  end

end

# if needed first partition into 4 files, hashed on place name

pid_to_name = {}   # { 3424 => 'bobs cafe', ... }
place_to_pois = {} # { 'sydney' => [3424, 234, 3453], ... }
STDIN.each do |line| 
  pid,poi_name,place = line.chomp.split("\t")
  pid_to_name[pid] = poi_name
  place_to_pois[place] ||= []
  place_to_pois[place] << pid
end

place_to_pois.each do |place, poi_ids|
  next unless poi_ids.length > 2
  (0...poi_ids.size).each do |i|
    poi1 = pid_to_name[poi_ids[i]]
    ((i+1)...poi_ids.size).each do |j|
      poi2 = pid_to_name[poi_ids[j]]
      name_similarity = poi1.jaccard_similarity_to poi2
      next unless name_similarity > 0.6
      puts [name_similarity,poi_ids[i],poi_ids[j]].join("\t")
      #printf "%0.5f %5d %5d %50s %50s\n", name_similarity, i,j, poi1,poi2
    end
  end
end



