module ApplicationHelper
  # Helper method for making a float breaking block level element
  #
  # @example 
  #   <%= clear_break %>
  #   renders:
  #   <br clear='all' style='clear: both;'/>
  # 
  # @return [HTML Fragment] 
  # 
  # @api public
  def clear_break
    raw "<br clear='all' style='clear: both;'/>"
  end
  
  ##
  # Helper for creating a tooltip
  # 
  # @example
  #   Here is an example
  # 
  # @param [String] body
  # @param [String] title
  # @param [Integer] length
  # 
  # @return [HTML Fragment]
  # 
  # @author yogo
  # @api public
  def tooltip(body, title = nil, length = 10)
    id = UUIDTools::UUID.random_create
    if body.length > length
      <<-TT
      <div id='#{id}' class='tooltip' title='#{title || "Click to see full text."}'>#{body}</div>
      <span class='tooltip-snippet' onClick="$('##{id}').dialog('open')">
        #{body[0..length]}<span class='more'>&#8230; more</span>
      </span>
      TT
    else
      body
    end
  end
  
  # Creates the appropriate HTML for attributes on a model
  # 
  # For attributes that are files or images it makes a download link work for them
  # 
  # @example 
  #   <%- @model.usable_properties.each do |p| %>
  #     <%= yogo_show_helper(d, p, @project, @model) %>
  #   <%- end %>
  # 
  # @return [HTML Fragment] the HTML is either a string or a link to the file/image.
  # 
  # @api public
  def yogo_show_helper(item, property, project, model)
    case property
    # when DataMapper::Property::YogoImage
    #   file = item[property.name]
    #   file = file[0..15] + '...' if file.length > 15 
    #   img = image_tag(show_asset_project_yogo_data_path(project, model, item, :attribute_name => property.name), :width => '100px')
    #   link_target = detailed ? img : file
    #   link_to(link_target, show_asset_project_yogo_data_path(project, model, item, :attribute_name => property.name, :ext => '.png'), 
    #     :class => 'fancybox', :title => model.name)
    # when DataMapper::Property::YogoFile
    #   file = item[property.name]
    #   file = file[0..15] + '...' if file.length > 15 
    #   link_to(file, download_asset_project_yogo_data_path(project, model, item, :attribute_name => property.name))
    when DataMapper::Property::Text
      if !detailed && (item[property.name] && item[property.name].length > 15)
        tooltip(item[property.name])
      else
        item[property.name]
      end
    else
      item[property.name]
    end
  end
  
  
  # Return the kefed editor swf url
  #
  # @example
  #   kefed_editor_swf_url
  #
  # @return [String] the absolute url for the kefed editor swf
  #
  # @author Yogo Team
  #
  # @api public
  #
  def kefed_editor_swf_url
    tomcat_root_url + "blazeds/kefedEditor/KefedModelEditor.html?"
  end
  
  # Return the kefed editor swf url
  #
  # @example
  #   kefed_editor_swf_url
  #
  # @return [String] the absolute url for the kefed editor swf
  #
  # @author Yogo Team
  #
  # @api public
  #
  def kefed_navigator_swf_url
    tomcat_root_url + "blazeds/kefedEditor/KefedModelNavigator.html?"
  end
  
  # Return the kefed editor swf file path
  #
  # @example
  #   kefed_editor_swf_url
  #
  # @return [String] the absolute url for the kefed editor swf
  #
  # @author Yogo Team
  #
  # @api public
  #
  def kefed_editor_swf_path
    Rails.root / "vendor/blazeds/tomcat/webapps/blazeds/kefedEditor/BioScholar.swf"
  end
  
  def measurement_jump_box(data_collections, this_collection)
    output = "<select name='measurement_jump' id='measurement_jump' >"
    data_collections.each do |coll|
      #debugger
      output << "<option value='#{yogo_project_collection_items_url(coll.project, coll)}' "
      output << "selected = 'true'" if coll == this_collection
      output << ">#{coll.name}</option>"
    end
    output << "</select>"
  end
  
  def tomcat_root_url
    "http:%s:8400/" % root_url.match(/\/\/([\w\d]+\.*)+/)[0]
  end
  
  def kefed_storage_params
    params = '&'
    prsvr = Rails.configuration.database_configuration[Rails.env]['repositories']['yogo_persevere']
    persevere_url = "http://%s:%s/" % [prsvr['host'], prsvr['port']]
    ['model','schema','data'].each do |store|
      params += "&#{store}StoreUrl=" + CGI.escape(persevere_url)
      params += "crux__yogo_model%2F" if store == 'schema'
      params += "KefedModel%2F" if store == 'model'
    end
    params
  end
  
  def spreadsheet_header_select(headers, name)
    if headers.include?(name)
      result = name
    else 
      result = headers.select{|h| h.downcase.gsub(/[^a-z0-9]/,'') == name.downcase.gsub(/[^a-z0-9]/,'')}.first
    end
    return result ? result : ''
  end
end
