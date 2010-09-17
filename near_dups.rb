#!/usr/bin/env ruby
require 'set'

N_GRAM_LEN = 2
MIN_RESEMBLANCE = 0.4

class String

  def shingles
    return @cached if @cached       
    n_grams = Set.new
    utf_chars = " #{self} ".split(//u)
    (0..utf_chars.length-N_GRAM_LEN).each do |n|    
      n_grams << utf_chars.slice(n,N_GRAM_LEN).join
    end     
    @cached = n_grams
  end

  def jaccard_similarity_to other
    return 1.0 if other==self
    sa = shingles
    sb = other.shingles
    numerator = (sa.intersection sb).size
    denominator = (sa.union sb).size        
    numerator.to_f / denominator  
  end

end

pid_to_name = {}   # { 3424 => 'bobs cafe', ... }
place_to_pois = {} # { 'sydney' => [3424, 234, 3453], ... }
STDIN.each do |line| 
  next if line =~ /^poi_id/
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
      next unless name_similarity > MIN_RESEMBLANCE
      puts [name_similarity,poi_ids[i],poi_ids[j]].join("\t")
      #printf "XXX %0.5f %5d %5d %50s %50s\n", name_similarity, i,j, poi1,poi2
    end
  end
end



