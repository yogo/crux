require 'yogo/collection/data'

module Yogo
  module Collection
    class Data
      def asset_collection?
        self.kind_of?(Yogo::Collection::Asset)
      end
    
      def data_collection?
        self.kind_of?(Yogo::Collection::Data)
      end
      
      def kefed_ordered_schema 
        project.yogo_model.ordered_parameter_uids.map { |p|
          schema.select{|s| s.kefed_uid.upcase == p}.first
        }.compact
      end
      
      def measurement_schema
        schema.select{|s| s.kefed_uid.upcase == self.id.to_s.upcase}.first
      end
    end
  end
end