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
    :yogo
  end
  
  property :id,           Serial,                          :writer => :private
  property :source,       String,                          :writer => :private
  property :model_name,    String,   :field => 'modelName', :writer => :private
  property :type,         String,                          :writer => :private
  # property :dateTime,     DateTime, :field => 'dateTime',  :writer => :private
  property :description,  Text,                            :writer => :private
  property :uid,          String,                         :writer => :private
  property :edges,        DataMapper::Types::Raw,         :writer => :private
  property :nodes,        DataMapper::Types::Raw,         :writer => :private
  
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
  
  def measurement_parameters(muid)
    params = nodes['measurements'][muid]['dependsOn']
    nodes['parameters'].select{|k,v| params.include?(k)}
  end
  
  def kefed_measurements
    nodes['measurements'].map{|n| n.label }
  end
  
  def kefed_parameters
    nodes['parameters'].map{|p| n.label }
  end
end
