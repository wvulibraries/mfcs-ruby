require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rails'
  task.requires << 'rubocop-performance'
end