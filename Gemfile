source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Rails
# ================================================================
gem 'rails', '~> 6.0', '>= 6.0.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
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

# metadata / library of congress specific
gem 'edtf', '~> 3.0', '>= 3.0.4'
# gem 'edtf-humanize', '~> 0.0.7'

# breadcrumbs
gem 'loaf'

# configruation
gem "figaro"

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
  gem 'faker'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # from rails new
  gem 'pry'
  gem 'pry-rails'
  gem 'factory_bot_rails'
end

group :test do
  # test suite
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'rspec-html-matchers'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'capybara', '>= 2.15', '< 4.0'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  # performance helper
  gem 'bullet' # helps to eliminate N+1 Queries 
end