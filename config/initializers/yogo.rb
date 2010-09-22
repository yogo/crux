##
# Check to make sure the asset directory exists and make it if it doesn't
# TODO: If the user changes the setting we should make sure that directory exists...but we don't.
# if ! File.directory?(File.join(Rails.root, Yogo::Setting['asset_directory']))
#   FileUtils.mkdir_p(File.join(Rails.root, Yogo::Setting['asset_directory']))
# end

require 'facet'
require 'datamapper/property/raw'
require 'datamapper/search'
require 'yogo_data_form_builder'
require 'yogo_form_builder'
require 'yogo/chainable'
require 'yogo/collection_ext'
require 'yogo/datamapper/pagination'
require 'yogo/project_ext'
require 'yogo/responders/csv'
require 'yogo/responders/json'
require 'yogo/responders/pagination'

require 'will_paginate/view_helpers/action_view'
ActionView::Base.send(:include, WillPaginate::ViewHelpers::ActionView)

# Load the Application Version
load Rails.root / "VERSION"

# throw exceptions when models fail to save
DataMapper::Model.raise_on_save_failure = true