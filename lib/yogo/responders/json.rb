# Mix this in with the responder object to respond to JSON
# Customize resourse_json or collection_json for your particular controller if needed

module Yogo
  module Responders
    module Json
      def to_json
        case(resource)
        when DataMapper::Collection
          render :json => collection_json(resource)
        when DataMapper::Resource
          render :json => resource_json(resource)
        else
          # defer to super.to_format
          to_format
        end
      end

      protected

      def resource_path(*args)
        controller.send(:resource_path, *args)
      end
  
      def collection_path(*args)
        controller.send(:collection_path, *args)
      end

      # Overwrite per controller if necessary
      def resource_json(resource)
        hash = resource.as_json
        hash[:uri] = resource_path(resource)
        hash
      end

      def collection_json(collection)
        collection.map{|r| resource_json(r) }
      end
    end
  end
end