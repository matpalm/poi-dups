#!/usr/bin/env ruby

@freq = Hash.new(0)
STDIN.each do |line|
  line.downcase.split.each do |token|
    @freq[token] += 1
  end
end

def normalised n
  # 1.0 / n
  1.0 / (Math.log(n)+1)
end

# emit only non 1 freqs
# assume all other keys are freq 1
@freq.each do |token,freq|
  next if freq==1
  puts [freq,normalised(freq),token].join("\t")
end
