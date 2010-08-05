# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

class Yogo::ProjectsController < InheritedResources::Base
  respond_to :html, :json
  
  defaults :resource_class => Yogo::Project,
           :collection_name => 'projects',
           :instance_name => 'project'
  
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
    @project = Project.get(params[:id])
    @uid = @project.yogo_model_uid || params[:uid]
    @action = params[:action]
    @kefed_params = "callbackFunction=kefedEditorStatus"
    if params[:editor_action]
      @kefed_params += "&action=#{params[:editor_action]}"
    else
      @kefed_params += "&action=editModel"
    end
    @kefed_params += "&uid=#{@uid.upcase}" if @uid
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
    @project = Project.get(params[:id])
    @experimental_designs = Crux::YogoModel.all
  end
  
  def add_kefed_diagram
    @project = Project.get(params[:id])
    @project.yogo_model_uid = params[:uid]
    @project.save
    @project.build_models_from_kefed
    redirect_to project_url(@project)
  end
  
  protected

  def resource
    @project ||= collection.get(params[:id])
  end
  
  def collection
    @projects ||= resource_class.all.paginate(:page => params[:page], :per_page => 5)
  end
  
  def resource_class
    Yogo::Project
  end

end
