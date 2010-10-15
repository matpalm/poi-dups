#!/usr/bin/env ruby
require 'zlib'
require 'tokens'

N_GRAM_LEN = 2
MIN_RESEMBLANCE = 0.6

class String

  # standard ngrams
  def ngrams    
    return @_ngrams if @_ngrams
    n_grams = []
    whitespace_padding = " " * (N_GRAM_LEN-1)
    utf_chars = (whitespace_padding + self + whitespace_padding).split(//u)
    (0..utf_chars.length-N_GRAM_LEN).each do |n|    
      n_grams << utf_chars.slice(n,N_GRAM_LEN).join
    end     
    @_ngrams = n_grams
  end

  # ngrams weighted based on frequency of the token they are produced from
  def term_weighted_ngrams    
    ngrams.map{ |n| [ n, @@token_freqs[self] ] }    
  end

  # phrase broken into tokens
  # ngrams per token weighted based on that tokens frequency
  # weight of unique ngram derived by average of weights
  def phrase_weighted_ngrams
    return @_phrase_weighted_ngrams if @_phrase_weighted_ngrams
    
    non_unique_ngrams = []
    self.tokens.each do |token|
      non_unique_ngrams += token.term_weighted_ngrams
    end

    grouped_unique_ngrams = non_unique_ngrams.group_by { |nw| nw[0] }

    unique_ngrams = []
    grouped_unique_ngrams.keys.sort.each do |ngram|
      weights = grouped_unique_ngrams[ngram].map { |nw| nw[1] }
      weight_sum = weights.inject(&:+)
      average_weight = weight_sum.to_f / weights.size
      unique_ngrams << [ ngram, average_weight ]
    end

    @_phrase_weighted_ngrams = unique_ngrams
  end

  # jaccard similarity metric that allows fuzzy set membership (ie 0 to 1)
  def jaccard_similarity_to other
    return 1.0 if other==self

    union = intersection = 0.0

    set1, set2 = phrase_weighted_ngrams.clone, other.phrase_weighted_ngrams.clone
    while !(set1.empty? || set2.empty?)
      ngram1, weight1 = set1.first
      ngram2, weight2 = set2.first
      
      if ngram1 == ngram2
	average = (weight1.to_f + weight2)/2
        intersection += average
        union += average
        set1.shift
        set2.shift
      elsif ngram1 < ngram2
	set1.shift
	union += weight1
      else # ngram1 > ngram2
	set2.shift
	union += weight2
      end

    end

    # what ever is left counts for the union size
    set1.each { |ngram,weight| union += weight }
    set2.each { |ngram,weight| union += weight }
    
    intersection.to_f / union
  end
  
end

# read token freqs
file = Zlib::GzipReader.open('freq.dat.gz')
@@token_freqs = Marshal.load(file.read)
file.close

# parse stdin
pid_to_name = {}     # { 3424 => 'bobs cafe', ... }
place_to_pois = {}   # { 'sydney' => [3424, 234, 3453], ... }
STDIN.each do |line| 
  next if line =~ /^poi_id/
  pid,poi_name,type,place = line.chomp.split("\t") 
  pid_to_name[pid] = poi_name
  place_to_pois[place] ||= []
  place_to_pois[place] << pid
end

# for each place
place_to_pois.each do |place, poi_ids|
  next unless poi_ids.length > 2
  # compare poi pairs
  (0...poi_ids.size).each do |i|
    poi1 = pid_to_name[poi_ids[i]]
    ((i+1)...poi_ids.size).each do |j|
      poi2 = pid_to_name[poi_ids[j]]
      name_similarity = poi1.jaccard_similarity_to poi2
      next unless name_similarity > MIN_RESEMBLANCE
      puts [name_similarity,poi_ids[i],poi_ids[j]].join("\t")
      #printf "%0.5f %5d %5d %50s %50s\n", name_similarity, i,j, poi1,poi2
    end
  end
end



