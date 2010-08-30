source 'http://rubygems.org'

RAILS_VERSION = '~> 3.0.0'
DM_VERSION    = '~> 1.0.0'
RSPEC_VERSION = '~> 2.0.0.beta.20'

gem 'activesupport',      RAILS_VERSION, :require => 'active_support'
gem 'actionpack',         RAILS_VERSION, :require => 'action_pack'
gem 'actionmailer',       RAILS_VERSION, :require => 'action_mailer'
gem 'railties',           RAILS_VERSION, :require => 'rails'
gem 'rails',              RAILS_VERSION, :require =>  nil
gem 'inherited_resources', '~> 1.1.2'

gem 'dm-rails',             '~> 1.0.3'
gem 'dm-sqlite-adapter',    DM_VERSION
gem 'dm-postgres-adapter',  DM_VERSION
gem "dm-persevere-adapter", "0.72.0", :require => nil

gem "will_paginate",        "~> 3.0.pre2", :git => 'git://github.com/yogo/will_paginate.git', 
                                           :branch => 'rails3'
gem 'dm-constraints',       DM_VERSION
gem 'dm-is-list',           DM_VERSION
gem 'dm-migrations',        DM_VERSION
gem 'dm-types',             DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-transactions',      DM_VERSION
gem 'dm-aggregates',        DM_VERSION
gem 'dm-timestamps',        DM_VERSION
gem 'dm-observer',          DM_VERSION

gem 'yogo-project',                     :require => 'yogo/project',
                                        :git => 'git://github.com/yogo/yogo-project.git'

gem 'haml'
gem 'compass',           '>=0.10.2'

gem 'devise',            '~> 1.1.1'
gem 'dm-devise',         '~> 1.1.0'

gem 'carrierwave',                     :git => 'git://github.com/jnicklas/carrierwave.git'

group :development, :test do
  platforms(:mri_19){ gem 'ruby-debug19'}
  platforms(:mri_18){ gem 'ruby-debug'}
  gem 'yard'
  gem 'rspec',              RSPEC_VERSION
  gem 'rspec-core',         RSPEC_VERSION, :require => 'rspec/core'
  gem 'rspec-expectations', RSPEC_VERSION, :require => 'rspec/expectations'
  gem 'rspec-mocks',        RSPEC_VERSION, :require => 'rspec/mocks'
  gem 'rspec-rails',        RSPEC_VERSION
  
  # To get a detailed overview about what queries get issued and how long they take
   # have a look at rails_metrics. Once you bundled it, you can run
   #
   #   rails g rails_metrics Metric
   #   rake db:automigrate
   #
   # to generate a model that stores the metrics. You can access them by visiting
   #
   #   /rails_metrics
   #
   # in your rails application.

   # gem 'rails_metrics', '~> 0.1', :git => 'git://github.com/engineyard/rails_metrics'
end

