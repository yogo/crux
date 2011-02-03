# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

require "fastercsv"
require 'ftools'

class Yogo::ProjectsController < Yogo::BaseController
  defaults :route_collection_name => :projects, :route_instance_name => :project
  
  caches_action :show

  # Setting some pagination for this controller
  def paginated_scope(relation)
    instance_variable_set("@projects", relation.paginate(:page => params[:page], :per_page => 10))
  end
  hide_action :paginated_scope

  ##
  # Show all the projects
  #
  # @example 
  #   get /yogo/projects
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
  
  # def show
  #   @collections = @project.kefed_ordered_data_collections
  #   super do |format|
  #     format.html
  #   end
  # end
  # 
  
  def create
    create! do |success, failure|
      success.html { redirect_to kefed_library_yogo_project_url(@project.id.to_s) }
    end
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
  
  
  # Load the kefed editor swf
  #
  # @example 
  #   get /yogo/projects/1/kefed_editor
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
    @kefed_params = "callbackFunction=editorCallback"
    if params[:editor_action]
      @kefed_params += "&action=#{params[:editor_action]}"
    else
      @kefed_params += "&action=editModel"
    end
    @kefed_params += "&uid=#{@uid.to_s.upcase}" if @uid
    @kefed_params += "&zoom=1.0"
    @no_blueprint = true 
  end
  
  # Load the kefed editor swf
  #
  # @example 
  #   get /yogo/projects/1/kefed_library
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
    expire_action :action => :show
    @project = Yogo::Project.get(params[:id])
    @project.yogo_model_uid = params[:uid]
    @project.save
    @project.build_models_from_kefed
    redirect_to yogo_project_url(@project)
  end
  
  # The import spreadsheet tool.  This is stateful.
  # @example
  #   get /yogo/projects/1/import_spreadsheet
  # I am so so sorry, this was a fit of madness. It started off so small...
  def import_spreadsheet
    @project = Yogo::Project.get(params[:id])
    @total_steps = 3

    case params[:step]
    when '2'
        file = copy_uploaded_file(params[:spreadsheet])
        session[:import_file] = file
        contents = FasterCSV.read(file)
        @headers = contents[0]
        @rows = contents.length - 1
        @measurements = params[:measurements].keys.map{|k| @project.data_collections.get k }
        @import_step = 2
    when '3'
      @measurements, @example, @sheet_rows = {}, {}, 0
      params['measurements'].each do |m_id, parameters|
        m = @project.data_collections.get m_id
        m_hash = {}
        m_hash['measurement'] = [m.measurement_schema.id, parameters.delete('measurement')]
        m_hash['parameters'] = []
        parameters.each do |p_id, header|
          p = m.schema.get p_id
          m_hash['parameters'] << [p, header]
        end
        @measurements[m] = m_hash
        @measurements[m]['count'] = 0
        @measurements[m]['example'] = {}
      end

      FasterCSV.foreach(session[:import_file], :headers => true) do |row|
        @headers ||= row.headers
        
        @measurements.each do |m, v|
          if @measurements[m]['example'].empty?
            @headers.each { |h| @measurements[m]['example'][h] = [] } 
          end
          unless row[v['measurement'][1]].blank?
            if @measurements[m]['count'] < 5
              row.each { |h, v| @measurements[m]['example'][h] << v }
            end
            @measurements[m]['count'] += 1 
          end
        end
        @sheet_rows += 1
      end
      session_hash = {}
      @measurements.each do |m,v|
        session_hash[m.id] = {
          'parameters' => v['parameters'].map{|p| [p[0].id, p[1]] }, 
          'measurement' => v['measurement']
        }
      end
      session[:measurements] = session_hash
      @import_step = 3
    when '4'
      @measurements = {}
      session[:measurements].each do |m_id,v|
        m = @project.data_collections.get(m_id)
        @measurements[m] = v
      end
      @measurements.each do |m,v|
        @measurements[m]['initial'] = m.items.all.count
        if params['replace_data'] && (params['replace_data'][m.id.to_s] == 'DELETE')
          m.items.all.destroy
        end
        @measurements[m]['deleted'] = @measurements[m]['initial'] - m.items.all.count
        @measurements[m]['added'] = 0
        @measurements[m]['errors'] = []
      end
      FasterCSV.foreach(session[:import_file], :headers => true) do |row|
        @headers ||= row.headers
        @measurements.each do |m, v|
          values = {}
          unless row[v['measurement'][1]].blank?
            fields = {}
            m.schema.each{|s| fields[s.id.to_s] = s.to_s.intern }
            v['parameters'].each do |p,h|
              values[fields[p.to_s]] = row[h]
            end
            values[fields[v['measurement'][0].to_s]] = row[v['measurement'][1]]
            d = m.data_model.new(values)
            if d.valid?
              d.save
            else
              @measurements[m]['errors'] << d.errors.full_messages.join(", ")
            end
            @measurements[m]['added'] += 1
          end
        end
      end
      @measurements.each_key{|m| @measurements[m]['total'] = m.items.all.count }
      @import_step = 4
    else
      @import_step = 1
    end

    render("import_spreadsheet_#{@import_step}")
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
  
  private 

  def copy_uploaded_file(file)
    tmpdir = Rails.root.to_s + '/tmp/csv_upload/' + File.basename(file.tempfile.path)
    File.makedirs(tmpdir)
    src = file.tempfile.path
    dest = tmpdir + '/' + file.original_filename
    File.copy(src, dest)
    dest
  end
  
end
