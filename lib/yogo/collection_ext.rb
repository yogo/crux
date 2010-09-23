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
    end
  end
end