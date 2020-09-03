

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Rails
# ================================================================
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0', '>= 6.0.2'
gem 'turbolinks', '~> 5.2.0'
gem 'webpacker', '~> 4.0', '>= 4.0.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Application Specific
# =================================================================

# elasticsearch
gem 'elasticsearch-model', '~> 6.0'
gem 'elasticsearch-rails', '~> 6.0'

# authentication
gem 'devise', '~> 4.6', '>= 4.6.2'
gem 'omniauth', '~> 1.9'
gem 'omniauth-cas', '~> 1.1', '>= 1.1.1'

# Log all changes to models
gem "audited", "~> 4.9"

# metadata / library of congress specific
gem 'edtf', '~> 3.0', '>= 3.0.4'
# gem 'edtf-humanize', '~> 0.0.7'

# breadcrumbs
gem 'loaf'

# configruation
gem 'figaro'

# convert user strings to regex
gem 'to_regexp', '~> 0.2.1'

# Test Suite
# =====================================================================================
# group :test do
#   # gem 'rspec-rails'
#   # gem 'shoulda'
#   # gem 'shoulda-matchers'
#   # gem 'database_cleaner'
#   # gem 'simplecov'
#   # gem 'simplecov-console'
#   # gem 'capybara', '>= 2.15', '< 4.0'
# end

# Developoment / Test Items (Primarily debugging)
# =====================================================================================
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # from rails new
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-rails'

  # Code critics
  gem 'rubocop', '>= 0.72', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  # test suite
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'database_cleaner'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-console'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  # performance helper
  gem 'bullet' # helps to eliminate N+1 Queries
end
