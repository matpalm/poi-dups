#!/usr/bin/env ruby

require 'rubygems'
require "rgl/adjacency"
require "rgl/traversal"
require "rgl/connected_components"

class MaxResForPid
  def initialize 
    @max_res_for_pid = Hash.new(0)
  end
  def new_value res, pid
    @max_res_for_pid[pid] = res if @max_res_for_pid[pid] < res
  end
  def max_res_for pids
    pids.map{|v| @max_res_for_pid[v]}.max
  end
end

g = RGL::AdjacencyGraph.new
max_res_for_pid = MaxResForPid.new

STDIN.each do |line|
  res,id1,id2 = line.split("\t")
  res,id1,id2 = res.to_f, id1.to_i, id2.to_i
  id1,id2 = id2,id1 unless id1 < id2
  g.add_vertex id1
  g.add_vertex id2
  g.add_edge id1, id2
  max_res_for_pid.new_value res, id1
  max_res_for_pid.new_value res, id2
end

g.each_connected_component do |vertexs| 
  max_res_in_group = max_res_for_pid.max_res_for vertexs
  printf "%0.3f\t", max_res_in_group
  puts vertexs.join("\t")
end

