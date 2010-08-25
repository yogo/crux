require 'yogo/project'

module Yogo
  class Project
    extend Permission
    
    property :is_private,      Boolean, :required => true, :default => false
    property :yogo_model_uid,  DataMapper::Property::UUID
    has n, :roles
    
    def self.extended_permissions
      collection_perms = [ :create_models, :retrieve_models, :update_models, :delete_models, :create_data, :retrieve_data, :update_data, :delete_data ]
      [:manage_users, collection_perms, super].flatten
    end
    
    def yogo_model
      # maybe cache this later
      @yogo_model = Crux::YogoModel.first(:uid => yogo_model_uid.to_s.upcase )
    end
    
    # Construct the models from the kefed diagram
    def build_models_from_kefed
      # Create models for each measurement
      yogo_model.nodes['measurements'].each do |muid, measurement|
        measurement_name = measurement['label']
        measurement_uid = measurement['uid']
        begin 
          measurement_type = measurement['schema']['type'].split('::').last
        rescue NameError
          measurement_type = "Text"
        end      
        
        # Initialize the parameters with a column for the measurement itself
        parameters = [{
          :label => measurement_name,
          :type  => measurement_type,
          :uid   => measurement_uid
        }]
        
        yogo_model.measurement_parameters(muid).each do |puid, param|
          param_name = param['label']
          param_uid  = param['uid']
          begin 
            param_type = param['schema']['type'].split('::').last
          rescue NameError
            param_type = "Text"
          end
          parameters << {:label => param_name, :type => param_type, :uid => param_uid}
        end
        
        # find or create the measurement collection
        measurement_model  = self.data_collections.first_or_create(:id => measurement_uid)
        measurement_model.attributes = { :name => measurement_name }
        measurement_model.save
        
        # find or create each of the parameters
        # there are side-effects here: don't change property names, it is data destructive
        parameters.each do |param, options|
          property = measurement_model.schema.first_or_new(:name => param[:label])
          property.attributes = { :name => param[:label], :type => param[:type]}
        end
        
        if measurement_model.save 
          puts "MODEL CREATED: #{measurement_model.name}"
          measurement_model.update_model
        end
        
        puts "NUMBER OF DATA_COLLECTIONS: #{self.data_collections.length}"
        puts "CURRENT DATA_COLLECTIONS: #{self.data_collections.map(&:name).join(',')}"
        
      end
    end

    def root_model
      data_collections.first
    end

    def kefed_ordered_models
      data_collections
    end
  end
end