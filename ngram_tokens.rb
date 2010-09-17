#!/usr/bin/env ruby

bigrams = []
STDIN.each do |line|
  utf_chars = line.chomp.downcase.split(//u)
  next unless utf_chars.length > 2
  (0..utf_chars.length-2).each do |n|
    bigram = utf_chars.slice(n,2).join
    bigrams << bigram
  end
end

puts bigrams.sort.map{|f| "['#{f}',]"}.join(",")

