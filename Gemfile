source 'http://rubygems.org'

RAILS_VERSION = '~> 3.0.0.beta4'

DM_VERSION    = '~> 1.0.0'

RSPEC_VERSION = '~> 2.0.0.beta.17'

gem 'activesupport',      RAILS_VERSION, :require => 'active_support'
gem 'actionpack',         RAILS_VERSION, :require => 'action_pack'
gem 'actionmailer',       RAILS_VERSION, :require => 'action_mailer'
gem 'railties',           RAILS_VERSION, :require => 'rails'
gem 'inherited_resources', '~> 1.1.2'

gem 'dm-rails',           DM_VERSION,    :git => 'git://github.com/datamapper/dm-rails.git'
gem 'dm-sqlite-adapter',  DM_VERSION

gem "dm-persevere-adapter", '0.71.4', :require => nil, 
                                      :git => 'git://github.com/yogo/dm-persevere-adapter.git',
                                      :branch => 'ryan/yogo-integration'

gem 'dm-migrations',        DM_VERSION
gem 'dm-types',             DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-constraints',       DM_VERSION
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


group :development, :test do
  gem RUBY_VERSION.include?('1.9') ? 'ruby-debug19' : 'ruby-debug', :require => nil unless defined?(JRUBY_VERSION)
end

group(:test) do

  gem 'rspec',              RSPEC_VERSION
  gem 'rspec-core',         RSPEC_VERSION, :require => 'rspec/core'
  gem 'rspec-expectations', RSPEC_VERSION, :require => 'rspec/expectations'
  gem 'rspec-mocks',        RSPEC_VERSION, :require => 'rspec/mocks'
  gem 'rspec-rails',        RSPEC_VERSION

end

# ------------------------------------------------------------------------------

# These gems are only listed here in the Gemfile because we want to pin them
# to the github repositories for as long as no stable version has been released.
# The dm-core gem is a hard dependency for dm-rails so it would get pulled in by
# simply adding dm-rails. The dm-do-adapter gem is a hard dependency for any of
# the available dm-xxx-adapters. Once we have stable gems available, pinning these
# gems to github will be optional.

gem 'dm-core',              DM_VERSION
gem 'dm-do-adapter',        DM_VERSION
gem 'dm-active_model',      DM_VERSION

# This is a datamapper compatibility branch for EngineYard's Rails metrics gem.
# In the future this will hopefully be merged into the mainly gem. We refer to
# this gem now so you can easily add it to your project

# gem 'rails_metrics', '~> 0.1', :git => 'git://github.com/engineyard/rails_metrics'

