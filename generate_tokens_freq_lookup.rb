#!/usr/bin/env ruby
require 'zlib'
require 'tokens'

freq = Hash.new(0)
STDIN.each do |line|
  line.tokens.each do |token|
    freq[token] += 1
  end
end

# convert into normalised hash with default 1
freq2 = Hash.new(1)
freq.each do |token,n|
  if n != 1
    freq2[token] = 1.0 / (Math.log(n)+1)
  end
end

file = Zlib::GzipWriter.new(File.new('freq.dat.gz','w'))
file.write Marshal.dump(freq2)
file.close

# read back with
# file = Zlib::GzipReader.open('freq.dat.gz')
# freq = Marshal.load(file.read)
# file.close
