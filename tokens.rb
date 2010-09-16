#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'

# -*- coding: utf-8 -*-
@token_freq = Hash.new(0)
@total_tokens = 0
STDIN.each do |line|
  line.chomp.gsub("’","'").downcase.split.each do |token|
    @token_freq[token] += 1
    @total_tokens += 1
  end
end

def normalised n
  # 1.0 / n
  1.0 / (Math.log(n)+1)
end

# emit only non 1 freqs
# assume all other keys are freq 1
@token_freq.each do |token,freq|
  if freq!=1
    puts [freq,normalised(freq),token].join("\t")
  end
end
