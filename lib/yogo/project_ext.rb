require 'yogo/project'

module Yogo
  class Project
    # extend Permission
    include Facet::DataMapper::Resource
    
    property :is_private,      Boolean, :required => true, :default => false
    
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
