#!/usr/bin/env ruby
require 'zlib'
file = Zlib::GzipReader.open('freq.dat.gz')
freq = Marshal.load(file.read)
puts freq.inspect
file.close
