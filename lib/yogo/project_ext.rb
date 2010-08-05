require 'yogo/project'

module Yogo
  class Project
    extend Permission
    
    property :is_private,      Boolean, :required => true, :default => false
    property :yogo_model_uid,  DataMapper::Property::UUID
    has n, :roles
    
    belongs_to :yogo_model, :model => 'Crux::YogoModel', :child_key => [:yogo_model_uid], :parent_key => [:uid]
    
    def self.extended_permissions
      collection_perms = [ :create_models, :retrieve_models, :update_models, :delete_models, :create_data, :retrieve_data, :update_data, :delete_data ]
      [:manage_users, collection_perms, super].flatten
    end
    
    # Please refactor me, here there be dragons.  
    # This is not awesome.
    # 
    def build_models_from_kefed
      kefed_model = Crux::YogoModel.first(:uid => self.yogo_model_uid )
      # Create models for each measurement
      kefed_model.nodes['measurements'].each do |muid, measurement|
        measurement_name = measurement['label']
        measurement_uid = measurement['uid']
        begin 
          measurement_type = measurement['schema']['type'].constantize
        rescue NameError
          measurement_type = DataMapper::Property::Text
        end      
        
        # # Initialize the parameters for a measurement with a series integer and the column for 
        # the measurement itself
        parameters = {
          :series =>                  {:type => Integer},
          measurement_name.tableize.to_sym =>  {:type => measurement_type}
        }
        
        kefed_model.measurement_parameters(muid).each do |puid, param|
          p_name = param['label']
          begin 
            param_type = param['schema']['type'].constantize
          rescue NameError
            param_type = DataMapper::Property::Text
          end
          parameters[p_name] = {:type => param_type}
        end
        
        # # find or create the measurement collection
        measurment_model  = self.data_collections.get(measurement_uid)        
        if measurement_model.nil?
          measurment_model = self.data_collections.new(:id => measurement_uid, :name => measurement_name )
        end
        
        # find or create each of the parameters
        parameters.each do |param, options|
          property = measurement_model.schema.get(param['uid'])
          if property.nil?
            property = measurement_model.schema.new(:id  => param['uid'], :name => param['label'], :type => param['schema']['type'])
          else
            property.attributes = { :name => param['label'], :type => param['schema']['type']}
          end
        end
        measurement_model.save
        measurement_model.update_model
      end
    end

    def root_model
      data_collections.first
    end

    def kefed_ordered_models
      data_collections
      # kefed_model = Crux::YogoModel.first(:uid => self.yogo_model_uid )
      # sorted_models = []
      # kefed_model.nodes['measurements'].each do |muid, m|
      #   num_deps = m['dependsOn'].size
      #   if sorted_models[num_deps]
      #     sorted_models[num_deps] << m['label'].gsub(/\W|\s/,'_').tableize.classify
      #   else
      #     sorted_models[num_deps] = [m['label'].gsub(/\W|\s/,'_').tableize.classify]
      #   end
      # end
      # sorted_models.flatten.map{|m| models.select{|n| n.class.to_s.include?(m) }}.flatten.compact
    end
    
  end
end