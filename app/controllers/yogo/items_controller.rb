require "fastercsv"

class Yogo::ItemsController < Yogo::BaseController
  defaults :collection_name => 'items',
           :instance_name => 'item'
  
  belongs_to :project, :parent_class => Yogo::Project, :finder => :get, :collection_name => :data_collections
  belongs_to :data_collection, :parent_class => Yogo::Collection::Data, :finder => :get, :param => :collection_id
  
  before_filter :no_blueprint
  
  def paginated_scope(relation)
    instance_variable_set("@items", relation.paginate(:page => params[:page], :per_page => 25))
  end
  hide_action :paginated_scope
  
  def create
    if params.has_key?(:csv_file)
      # Do Goo!
      parse_csv(params[:csv_file][:csv_file_name])
      redirect_to(:action => :index)
    else
      params[:item].delete_if{|key,value| value.blank?}
      super do |success, failure|
        success.html {redirect_to :action => :index}
        failure.html {redirect_to :action => :index}
      end
    end
  end
  
  def destroy
    super do |success, failure|
      success.html {redirect_to :action => :index}
      failure.html {redirect_to :action => :index}
    end
  end
  
  def search
    @search_collection = collection.search(params[:q])
    respond_with(@search_collection)
  end
  
  def update
    super do |success, failure|
      success.html {redirect_to :action => :edit}
      failure.html {redirect_to :action => :edit}
    end
  end
  
  protected
  
  def collection
    @items ||= end_of_association_chain.all
  end
  
  def resource
    @item ||= collection.get(params[:id])
  end
  
  def build_resource
    if data = parsed_body
      item_data = data['data'] || {}
      get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, data || {}))
    else
      super
    end
  end
  
  def update_resource(object, attributes)
    attributes = attributes || parsed_body
    attributes.delete('id')
    # attributes = attributes['data'] || {}
    attr_keys = object.attributes.keys.map{|key| key.to_s }
    valid_attributes = attributes.inject({}) {|h,(k,v)| h[k]=v if attr_keys.include?(k); h }
    object.attributes = valid_attributes
    object.save
  end
  
  with_responder do
    def resource_json(item)
      data_collection = controller.send(:parent)
      project = data_collection.project
      
      hash = {}
      hash[:data] = item.as_json
      hash[:uri] = controller.send(:yogo_project_collection_item_path, project, data_collection, item)
      hash[:data_collection] = controller.send(:yogo_project_collection_path, project, data_collection)
      hash
    end
  end
  
  with_responder do
    def csv_header
      data_collection = controller.send(:parent)
      data_collection.schema.map{|s| s.name }.join(',') << "\n"
    end
    
    def collection_csv(resource)
      data_collection = controller.send(:parent)
      result = ''
      resource.each do |item|
        result << data_collection.schema.map{|s| item.send(s.to_s) }.join(',') << "\n"
      end
      result
    end
  end

  private
    
  def method_for_association_build
    :new
  end
  
  def parse_csv(file)
    collection
    output = []
    contents = FasterCSV.read(file.path)
    header = contents[0]

    fields = {}
    @data_collection.schema.each{|s| fields[s.name] = s.to_s.intern }
    
    # fields = header.collect{|i| @data_collection.schema.first(:name => i).to_s.intern }
    # fields = @data_collection.schema.all(:name => header).map{|h| h.to_s.intern } )

    contents[3..-1].each do |row|
      tmp_hash = {}
      row.each_index do |i|
        tmp_hash[fields[header[i]]] = row[i] unless row[i].blank?
      end
      @data_collection.data_model.create(tmp_hash)
      # output << tmp_hash
    end
  end
  
end