# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

class Yogo::ProjectsController < Yogo::BaseController
  defaults :route_collection_name => :projects, :route_instance_name => :project

  # Setting some pagination for this controller
  def paginated_scope(relation)
    instance_variable_set("@projects", relation.paginate(:page => params[:page], :per_page => 5))
  end
  hide_action :paginated_scope

  ##
  # Show all the projects
  #
  # @example 
  #   get /projects
  #
  # @return [Array] Retrives all project and passes them to the view
  #
  # @author Yogo Team
  #
  # @api public
  def index
    super do |format|
      if collection.empty?
        @no_search = true
        @no_menu   = true 
        format.html { render('no_projects') }
      else
        format.html 
      end
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to kefed_library_yogo_project_url(@project.id.to_s) }
    end
  end
  
  
  # Load the kefed editor swf
  #
  # @example 
  #   get /projects/1/kefed_editor
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return [Page] returns page with the embedded kefed editor
  #
  # @author Pol Llovet <pol.llovet@gmail.com>
  #
  # @api semipublic
  def kefed_editor
    @project = Yogo::Project.get(params[:id])
    @uid = @project.yogo_model_uid || params[:uid]
    @action = params[:action]
    @kefed_params = "callbackFunction=kefedEditorStatus"
    if params[:editor_action]
      @kefed_params += "&action=#{params[:editor_action]}"
    else
      @kefed_params += "&action=editModel"
    end
    @kefed_params += "&uid=#{@uid.to_s.upcase}" if @uid
    @no_blueprint = true 
  end
  
  # Load the kefed editor swf
  #
  # @example 
  #   get /projects/1/kefed_library
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return [Page] returns page with the embedded kefed editor
  #
  # @author Pol Llovet <pol.llovet@gmail.com>
  #
  # @api semipublic
  def kefed_library
    @project = Yogo::Project.get(params[:id])
    @experimental_designs = repository(:yogo_persevere){ Crux::YogoModel.all }
  end
  
  def add_kefed_diagram
    @project = Yogo::Project.get(params[:id])
    @project.yogo_model_uid = params[:uid]
    @project.save
    @project.build_models_from_kefed
    redirect_to yogo_project_url(@project)
  end
  
  # def update
  #   if update! do |success, failure|
  #     if success
  #       flash[:notice] = "Project #{resource.name} was successfully updated."
  #     if failure
  #       flash[:notice] = "Project #{resource.name} was not updated."
  #   end
  # end
  
  def destroy
    if resource.destroy!
      flash[:notice] = "Project #{resource.name} was successfully deleted."
    else
      flash[:error] = "Project #{resource.name} was not deleted."
    end
    redirect_to( yogo_projects_path )
  end
  
  protected

  def resource
    @project ||= resource_class.get(params[:id])
  end
  
  def collection
    @projects ||= resource_class.all #.paginate(:page => params[:page], :per_page => 5)
  end
  
  def resource_class
    Yogo::Project
  end
  
  with_responder do
    def resource_json(project)
      hash = super(project)
      hash[:data_collections] = project.data_collections.map do |c| 
        controller.send(:yogo_project_collection_path, project, c)
      end
      hash
    end
  end
  
end
