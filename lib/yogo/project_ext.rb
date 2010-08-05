require 'yogo/project'

module Yogo
  class Project
    extend Permission
    
    property :is_private,      Boolean, :required => true, :default => false
    
    has n, :roles
    
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
        measurement_name = measurement['label'].gsub(/\W|\s/,'_').tableize.classify
        begin 
          measurement_type = measurement['schema']['type'].constantize
        rescue NameError
          measurement_type = DataMapper::Types::Text
        end      
        parameters = {
          :series =>                  {:type => Integer},
          measurement_name.tableize.to_sym =>  {:type => measurement_type}
        }
        kefed_model.measurement_parameters(muid).each do |puid, param|
          p_name = param['label'].gsub(/\W|\s/,'_')
          begin 
            param_type = param['schema']['type'].constantize
          rescue NameError
            param_type = DataMapper::Types::Text
          end
          parameters[p_name] = {:type => param_type}
        end
        measurement_model = get_model(measurement_name)
        if measurement_model.nil?
          a_model = add_model(measurement_name, parameters)
          a_model.auto_migrate! if a_model
        else
          # update the model and add only the new properties
          parameters.each do |param, options|
            unless measurement_model.respond_to?(param)
              measurement_model.send(:property, param, options.delete(:type), options.merge(:prefix => 'yogo'))
            end
          end

          measurement_model.auto_upgrade!
        end
      end
    end

    def root_model
      models.first
    end

    def kefed_ordered_models
      models
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