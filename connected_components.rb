#!/usr/bin/env ruby

require 'rubygems'
require "rgl/adjacency"
require "rgl/traversal"
require "rgl/connected_components"

# build graph
g = RGL::AdjacencyGraph.new
STDIN.each do |line|
  res,id1,id2 = line.split("\t")
  res,id1,id2 = res.to_f, id1.to_i, id2.to_i
  id1,id2 = id2,id1 unless id1 < id2
  g.add_vertex id1
  g.add_vertex id2
  g.add_edge id1, id2
end

# emit the group each vertex is in
group_idx = 0
g.each_connected_component do |vertexs| 
  vertexs.each do |vertex|
    puts "#{group_idx}\t#{vertex}"
  end
  group_idx += 1
end

