#!/usr/bin/env ruby
require 'set'

N_GRAM_LEN = 2
MIN_RESEMBLANCE = 0.4

class String

  def shingles
    return @cached if @cached       
    n_grams = []
    utf_chars = self.split(//u)
    (0..utf_chars.length-N_GRAM_LEN).each do |n|    
      n_grams << utf_chars.slice(n,N_GRAM_LEN).join
    end     
    @cached = n_grams.sort.uniq
  end

  def jaccard_similarity_to other
    return 1.0 if other==self
    puts "----\ncomparing [#{self}] to [#{other}]"

    union = 0
    intersection = 0

    i1 = i2 = 0
    s1,s2 = shingles.clone, other.shingles.clone

    while !(s1.empty? || s2.empty?)
      puts 
      puts "s1=#{s1.inspect}"
      puts "s2=#{s2.inspect}"

      b1,b2 = s1.first, s2.first

      if b1==b2
        puts "same"
        intersection += 1
        union += 1
        s1.shift
        s2.shift
      elsif b1 < b2
        puts "b1 < b2"
	s1.shift
	union += 1
      else # b1 > b2
        puts "b1 > b2"
	s2.shift
	union += 1
      end

      puts "union=#{union} intersection=#{intersection}"

    end

    puts "final"
    puts "s1=#{s1.inspect}"
    puts "s2=#{s2.inspect}"

    # what ever is left counts for the union size
    union += s1.size + s2.size
      
    intersection.to_f / union
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
      #puts [name_similarity,poi_ids[i],poi_ids[j]].join("\t")
      printf "XXX %0.5f %5d %5d %50s %50s\n", name_similarity, i,j, poi1,poi2
    end
  end
end



