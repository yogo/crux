class Yogo::BaseController < InheritedResources::Base
  respond_to :html, :json, :csv

  # Search through all collections that are available, and produce a result list
  def search
    @project = Yogo::Project.get(params[:project_id])
    results = @project.data_collections.map do |collection|
      [collection, collection.search(params[:q]).count]
    end
    respond_with(results)
  end
  
  chainable do
    def parsed_body(format=request.content_type)
      return nil unless format
      format_method = "body_#{format.to_sym}".to_sym
      
      if respond_to?(format_method)
        begin
          send(format_method)
        rescue
          false
        end
      else
        false
      end
    end
    
    protected
    
    def body_json
      JSON.parse(request.body.string)
    end
  end
  
  chainable do
    def build_resource
      if data = parsed_body
        get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, data || {}))
      else
        super
      end
    end
    
    def update_resource(object, attributes)
      attributes = attributes || parsed_body
      attributes.delete('id')
      attr_keys = object.attributes.keys.map{|key| key.to_s }
      valid_attributes = attributes.inject({}) {|h,(k,v)| h[k]=v if attr_keys.include?(k); h }
      object.attributes = valid_attributes
      object.save
    end
  end
  
  with_responder do
    include Responders::FlashResponder
    include Responders::HttpCacheResponder
    include ::Yogo::Responders::Json
    include ::Yogo::Responders::Csv
    include ::Yogo::Responders::Pagination
  end
  
  public
  
  # # This should be implemented in controllers for customizing pagination
  # def paginated_scope(relation)
  #   instance_variable_set("@#{controller.controller_name}", relation.paginate(:page => controller.params[:page]))
  # end
  # hide_action :paginated_scope
end