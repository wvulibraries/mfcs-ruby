abort "Nothing to do here" if ARGV.blank? 
ARGV.each do |klass_name|
  klass = klass_name.classify.constantize
  puts "\n\t#{klass_name} has #{klass_name.classify.constantize.count} records."
    puts "\t\t Destroying records ... "
    klass.destroy_all 
    ActiveRecord::Base.connection.reset_pk_sequence!(klass.table_name)
  puts "\tAfter destroying #{klass_name} records, there are #{klass_name.classify.constantize.count} records and has been indexed back to 1 for id columns.\n\r"
end
