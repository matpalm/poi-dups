#!/usr/bin/env ruby

require 'set'

N_GRAM_LEN = 3

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

Poi = Struct.new :name, :place
pois = STDIN.collect { |line| Poi.new(*line.chomp.split("\t")) }

def compare poi1, poi2 
  name_similarity = poi1.name.jaccard_similarity_to poi2.name
  return if name_similarity==0
  printf "%0.5f %050s %050s\n", name_similarity, "#{poi1.name} (#{poi1.place})", "#{poi2.name} (#{poi2.place})"
end

# order n-squared! yeah baby! 
# todo partition by place
(0...pois.size).each do |i|
  poi1 = pois[i]
  ((i+1)...pois.size).each do |j|
    compare poi1,pois[j]
  end
end
