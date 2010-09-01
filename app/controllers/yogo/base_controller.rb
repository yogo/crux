class Yogo::BaseController < InheritedResources::Base
  respond_to :html, :json, :csv
  
  extend Yogo::Chainable
  self.responder = Class.new(::ActionController::Responder)
  
  
  def search
    @search_collection = collection.search(params[:q])
    respond_with(@search_collection)
  end
  
  extendable do
    def with_responder(&block)
      self.responder = Class.new(self.responder || ::ActionController::Responder)
      self.responder.extend(Yogo::Chainable)
      self.responder.chainable(&block)
      self.responder
    end
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
  end
  
  # Handle Pagination
  with_responder do
    def to_html
      if get? && resource.is_a?(DataMapper::Collection)
        controller.paginated_scope(resource)
      end
      super
    end
  end
  
  # Handle json
  with_responder do
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
  
    def resource_json(resource)
      hash = resource.as_json
      hash[:uri] = resource_path(resource)
      hash
    end

    def collection_json(collection)
      collection.map{|r| resource_json(r) }
    end
    
  end
  
  with_responder do
    def to_csv
      case(resource)
      when DataMapper::Collection
        controller.send_data(csv_header + resource_csv(resource), :type => :csv)
      when DataMapper::Resource
        controller.send_data(csv_header + resource.to_csv, :type => :csv)
      else
        to_format
      end
    end
    
    def csv_header(resource)
      ''
    end
    
    def resource_csv(resource)
      result = ''
      resource.each do |item|
        result << item.to_csv
      end
      result
    end
  end
  
  public
  
  # This should be implemented in controllers for pagination
  def paginated_scope(relation)
    instance_variable_set("@#{controller.controller_name}", relation.paginate(:page => controller.params[:page], :per_page => 25))
  end
  hide_action :paginated_scope
end