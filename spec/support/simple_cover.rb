# spec/support/simple_cover.rb
require 'simplecov'
require 'simplecov-json'
#require 'simplecov-console'

SimpleCov.formatter = SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

# SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
#   SimpleCov::Formatter::HTMLFormatter,
#   SimpleCov::Formatter::JSONFormatter,
#   SimpleCov::Formatter::Console
# ])

SimpleCov.start do
  add_filter %r{^/spec/}
  add_filter %r{^/bin/}
  add_filter %r{^/config/}
  add_filter %r{^/app/helpers/}
end
