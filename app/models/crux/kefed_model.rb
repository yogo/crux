# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: kefed_model.rb
# The KefedModel schema in persevere holds the internal data used by the kefed editor.
#
# Class for a KefedModel object. A KefedModel contains information about the kefed experimental
# design graph.
class Crux::KefedModel
  include DataMapper::Resource
  
  property :id,        Serial,                          :writer => :private
  property :source,    String,                          :writer => :private
  property :modelName, String,  :field => 'modelName',  :writer => :private
  property :type,      String,                          :writer => :private
  property :dateTime,  DateTime,:field => 'dateTime',   :writer => :private
  property :description, Text,                          :writer => :private, :lazy => false
  property :diagramXML,  Text,  :field => 'diagramXML', :writer => :private, :lazy => false
  property :uid,       DataMapper::Types::UUID,         :writer => :private
  property :edges,     DataMapper::Types::Json,         :writer => :private, :lazy => false
  property :nodes,     DataMapper::Types::Json,         :writer => :private, :lazy => false
  
  def self.default_storage_name
    'KefedModel'
  end
  
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
  
end
