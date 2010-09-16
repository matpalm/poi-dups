#!/usr/bin/env ruby

@bigram_freq = Hash.new(0)
STDIN.each do |line|
  utf_chars = line.chomp.downcase.split(//u)
  next unless utf_chars.length > 2
  (0..utf_chars.length-2).each do |n|
    bigram = utf_chars.slice(n,2).join
    @bigram_freq[bigram] += 1
  end
end

def normalised n
  # 1.0 / n
  1.0 / (Math.log(n)+1)
end

# emit only non 1 freqs
# assume all other keys are freq 1
@bigram_freq.each do |token,freq|
  next if freq==1
  puts [freq,normalised(freq),token].join("\t")
end
