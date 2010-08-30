require 'yogo/project'

module Yogo
  class Project
    # extend Permission
    include Facet::DataMapper::Resource
    
    property :is_private,      Boolean, :required => true, :default => false
    property :yogo_model_uid,  DataMapper::Property::UUID
    
    has n, :memberships, :parent_key => [:id], :child_key => [:project_id], :model => 'Membership'
    has n, :roles, :through => :memberships
    has n, :users, :through => :memberships
    
    after :create, :give_current_user_membership
    before :destroy, :destroy_cleanup
    
    # def self.extended_permissions
    #   collection_perms = ['collection', 'item'].map do |elem|
    #     self.basic_permissions.map{|p| "#{p}_#{elem}".to_sym }
    #   end
    #   
    #   # collection_perms = [ :create_collection, :retrieve_collection, :update_collection, :delete_collection, :create_data, :retrieve_data, :update_data, :delete_data ]
    #   [:manage_users, collection_perms, super].flatten
    # end
    
    def self.permissions_for(user)
      # By default, all users can retrieve projects
      (super << "#{permission_base_name}$retrieve").uniq
    end
    
    def yogo_model
      # maybe cache this later
      @yogo_model = Crux::YogoModel.first(:uid => yogo_model_uid.to_s.upcase )
    end
    
    # Construct the models from the kefed diagram
    def build_models_from_kefed
      yogo_model.measurements.each do |measurement_uid, measurement|
        
        collection_opts = {:id => measurement_uid}
        if Crux::YogoModel.is_asset_measurement?(measurement)
          collection_opts[:type] = 'Yogo::Collection::Asset'
        end
        
        collection = self.data_collections.first_or_create(collection_opts)
        collection.attributes = { :name => measurement['label'] }
        collection.save

        yogo_model.measurement_parameters(measurement_uid).each do |parameter_uid, parameter|
          property = collection.schema.first_or_new(:name => parameter['label'])
          property.attributes = { 
            :name => parameter['label'], 
            :type  => Crux::YogoModel.legacy_type(parameter),
            :options => {:required => false}
          }
        end
        
        if collection.save 
          collection.update_model
        end
      end
    end

    def root_model
      data_collections.first
    end

    def kefed_ordered_models
      data_collections
    end
    ##
    # 
    def permissions_for(user)
      @_permissions_for ||= {}
      @_permissions_for[user] ||= begin
        base_permission = []
        base_permission << "#{permission_base_name}$retrieve" unless self.is_private?
        return base_permission if user.nil?
        (super + base_permission + user.memberships(:project_id => self.id).roles.map{|r| r.actions }).flatten.uniq
      end
    end
    
    private
    
    def destroy_cleanup
      memberships.destroy
    end
    
    def give_current_user_membership
      unless User.current.nil?
        Membership.create(:user => User.current, :project => self, :role => Role.first(:position => 1))
      end
    end

  end
end
