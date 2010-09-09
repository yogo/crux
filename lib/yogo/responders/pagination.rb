# Mix this in with the responder object to respond to JSON
# Create a paginated_scope method in the controller to customize the pagination count

module Yogo
  module Responders
    module Pagination
      def to_html
        if get? && resource.is_a?(::DataMapper::Collection)
          if controller.respond_to?(:paginated_scope)
            controller.paginated_scope(resource)
          else
            controller.instance_variable_set("@#{controller.controller_name}", 
                                              relation.paginate(:page => controller.params[:page]))
          end
        end
        super
      end
    end
  end
end