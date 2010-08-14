#!/usr/bin/env ruby

require 'rubygems'
require "rgl/adjacency"
require "rgl/traversal"
require "rgl/connected_components"

incident_edge_sum = {}
incident_edge_sum.default = 0

g = RGL::AdjacencyGraph.new

STDIN.each do |line|
  res,id1,id2 = line.split("\t")
  res,id1,id2 = res.to_f, id1.to_i, id2.to_i
  incident_edge_sum[id1] += res
  incident_edge_sum[id2] += res
  g.add_vertex id1
  g.add_vertex id2
  g.add_edge id1, id2
end

g.each_connected_component do |vertexs| 
  max_sum = 0
  max_vert = nil
  vertexs.each do |vertex|
    if incident_edge_sum[vertex] > max_sum
      max_sum = incident_edge_sum[vertex]
      max_vert = vertex
    end
  end
  vertexs.delete max_vert
  puts "#{max_vert} #{vertexs.join(' ')}"
end
