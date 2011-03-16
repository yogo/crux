source 'http://rubygems.org'

# Versions
RAILS_VERSION = '~> 3.0.0'
DM_VERSION    = '~>1.0.0'
RSPEC_VERSION = '~> 2.3.0'

# Rails
gem 'activesupport',      RAILS_VERSION,   :require => 'active_support'
gem 'actionpack',         RAILS_VERSION,   :require => 'action_pack'
gem 'actionmailer',       RAILS_VERSION,   :require => 'action_mailer'
gem 'railties',           RAILS_VERSION,   :require => 'rails'
gem 'rails',              RAILS_VERSION,   :require =>  nil

# Lean Controllers (TODO: evaluate this)
gem 'inherited_resources', '~> 1.1.2'

# DataMapper
gem 'dm-core',              DM_VERSION
gem 'dm-rails',             DM_VERSION
gem 'dm-sqlite-adapter',    DM_VERSION,    :require => nil
gem 'dm-mysql-adapter',     DM_VERSION,    :require => nil
gem "dm-persevere-adapter", "0.72.0",      :require => nil
gem 'dm-constraints',       DM_VERSION
gem 'dm-is-list',           DM_VERSION
gem 'dm-migrations',        DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-transactions',      DM_VERSION
gem 'dm-aggregates',        DM_VERSION
gem 'dm-timestamps',        DM_VERSION
gem 'dm-observer',          DM_VERSION

# 1.0 Release of dm-types has problems with UUID properties, use git master
gem "dm-types",             DM_VERSION,    :git => "git://github.com/datamapper/dm-types.git",
                                           :ref => "674738f2a94788b975e9",
                                           :require => false # don't require dm-type/json

gem 'yogo-project',                        :require => 'yogo/project',
                                           :branch => 'topic/ruby19',
                                           :git => 'git://github.com/yogo/yogo-project.git'

# View/CSS
gem 'haml'
gem 'compass',              '>=0.10.2'

# Auth (not required for crux)
# gem 'devise',            '~> 1.1.1'
# gem 'dm-devise',         '~> 1.1.0'

# Attachments
gem 'carrierwave',                         :git => 'git://github.com/jnicklas/carrierwave.git'

group :development, :test do

  # Dev Webserver
  gem 'passenger',                          :require => nil
  
  # Deployment
  gem 'capistrano',                         :require => nil

  platforms(:mri_19){ gem 'ruby-debug19'}
  platforms(:mri_18){ gem 'ruby-debug'}
  gem 'yard'
  gem 'rspec',              RSPEC_VERSION
  gem 'rspec-core',         RSPEC_VERSION, :require => 'rspec/core'
  gem 'rspec-expectations', RSPEC_VERSION, :require => 'rspec/expectations'
  gem 'rspec-mocks',        RSPEC_VERSION, :require => 'rspec/mocks'
  gem 'rspec-rails',        RSPEC_VERSION
  gem 'autotest'
  gem 'webrat'

  # For metrics
  #   rails g rails_metrics Metric
  #   rake db:automigrate

  # gem 'rails_metrics', '~> 0.1', :git => 'git://github.com/engineyard/rails_metrics'
end
