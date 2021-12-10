# spec/support/simple_cover.rb
require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::Console

SimpleCov.start do
  add_filter %r{^/spec/}
  add_filter %r{^/bin/}
  add_filter %r{^/config/}
  add_filter %r{^/app/helpers/}
end
