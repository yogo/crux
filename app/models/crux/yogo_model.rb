# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_model.rb
# The YogoModel schema in persevere holds the data exported by the kefed editor for Yogo.
#
# Class for a YogoModel object. A YogoModel contains information about the kefed experimental
# design graph.
class Crux::YogoModel
  include DataMapper::Resource
  
  def self.default_repository_name
    :collection_data
  end
  
  property :id,           Serial,                          :writer => :private
  property :source,       String,                          :writer => :private
  property :model_name,    String,   :field => 'modelName', :writer => :private
  property :type,         String,                          :writer => :private
  # property :dateTime,     DateTime, :field => 'dateTime',  :writer => :private
  property :description,  Text,                            :writer => :private
  property :uid,          String,                         :writer => :private
  property :edges,        DataMapper::Property::Raw,         :writer => :private
  property :nodes,        DataMapper::Property::Raw,         :writer => :private
  
  has 1, :project, :model => 'Yogo::Project', :child_key => [:yogo_model_uid], :parent_key => [:uid]
  
  # The number of items to be displayed (by default) per page
  # 
  # @example
  #   Project.per_page
  # 
  # @return [Fixnum]
  # 
  # @api public
  def self.per_page
    15
  end
  
  ##
  # Compatability method for rails' route generation helpers
  #
  # @example
  #   @project.to_param # returns the ID as a string
  # 
  # @return [String] the object id as url param
  #
  # @author Yogo Team
  #
  # @api public
  def to_param
    id.to_s
  end
  
  # This giant bit of commented code was a start at making normalized kefed
  # models. This feature was a bit premature. 
  
  # def kefed_graph
  #   return @kefed_graph if @kefed_graph
  #   @kefed_graph = RGL::DirectedAdjacencyGraph.new
  #   @kefed_obj_hash = {}
  #   # Add the nodes
  #   nodes.each do |node_type, nodes|
  #     nodes.each do |uid,node|
  #       node['node_type'] = node_type
  #       @kefed_obj_hash[uid] = node 
  #       @kefed_graph.add_vertex(uid)
  #     end
  #   end
  # 
  #   # Add the edges
  #   edges.each do |edge|
  #     @kefed_graph.add_edge(edge['start'], edge['end'])
  #     # @kefed_graph.add_edge(edge['end'], edge['start'])
  #   end
  #   @kefed_graph
  # end
  # 
  # def sorted_measurements
  #   # combine measurements that have the same dependsOn and 
  #   # have no non-measurement intermediate nodes
  #   combined_measurements = []
  #   measurements.each do |m|
  #     # these_measurements  = measurements.select{|n| n['dependsOn'].length == m['dependsOn'].length }
  #     
  #     # separate out the ones with intermediary non-measurement nodes
  #     # walk the edges until you find a non-measurement
  #     node_list = [m]
  #     node_descendents(m).each do |n|
  #       break unless n['node_type'] == 'measurement'
  #       node_list << n
  #     end
  #     combined_measurements << node_list
  #   end
  #   
  #   combined_measurements
  #   # discard duplicates
  #   # combined_measurements.uniq
  # end
  # 
  # def node_descendents(node)
  #   d = []
  #   kefed_graph.depth_first_visit(node['uid']){ |n| d << n }
  #   d.map{|n| @kefed_obj_hash[n] }
  # end
  # 
  # def measurement_models
  #   
  #   # grab the list of measurements, ordered by the number of depends-on items
  #   measurements = sorted_measuremnets
  #   
  #   # create a list of used parameters
  #   
  #   # for each measurement, add the specific parameters (careful of forks)
  #   
  #   # create the model list and store them
  # end
  # 
  # def root
  #   memo = nodes['measurements'].first[1]['dependsOn']
  #   nodes['measurements'].inject(memo){|m,v| m & v[1]['dependsOn']}[0]
  # end
  # 
  # def next_node_set(current_set = [])
  #   memo = nodes['measurements'].first[1]['dependsOn'] - current_set
  #   nodes['measurements'].inject(memo){|m,v| m & (v[1]['dependsOn'] - current_set) }
  # end
  # 
  # def measurements
  #   ordered_measurements
  # end
  # 
  # def ordered_measurements
  #   @measurements ||= nodes['measurements'].to_a.sort { |a,b| 
  #     a[1]['dependsOn'].length <=> b[1]['dependsOn'].length
  #   }.map{|m| m[1] }
  # end
  # 
  
  def measurements
    nodes['measurements']
  end
  
  # Return the params plus the measurement itself if appropriate
  def measurement_parameters(muid)
    params = measurements[muid]['dependsOn']
    measurement_params = nodes['parameters'].select{|k,v| params.include?(k)}
    unless Crux::YogoModel.is_asset_measurement?(measurements[muid])
      measurement_params << [muid, measurements[muid]]
    end
    measurement_params
  end
  
  def self.legacy_type(node)
    node['schema']['type'].split('::').last
  end
  
  def self.is_asset_measurement?(node)
    ['YogoImage','YogoFile'].include?(legacy_type(node))
  end
  
  def kefed_measurements
    nodes['measurements'].map{|n| n.label }
  end
  
  def kefed_parameters
    nodes['parameters'].map{|p| n.label }
  end
end
