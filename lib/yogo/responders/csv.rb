# Mix this in with the responder object to respond to CSV
# Overwrite csv_header to cusomize the CSV header
# Overwrite collection_csv to customize collection output

module Yogo
  module Responders
    module Csv
      def to_csv
        case(resource)
        when DataMapper::Collection
          controller.send_data(csv_header(resource) + collection_csv(resource), :type => :csv)
        when DataMapper::Resource
          controller.send_data(csv_header(resource) + resource.to_csv, :type => :csv)
        else
          to_format
        end
      end

      def csv_header(resource)
        ''
      end

      def collection_csv(resource)
        result = ''
        resource.each do |item|
          result << item.to_csv
        end
        result
      end
    end
  end
end