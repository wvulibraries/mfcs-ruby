abort 'Nothing to do here' if ARGV.present?

media = Media.find(15)
params = media.form.organized_hash[media.fieldname]

puts "Performing Conversion and Saving File \r\n"
Conversion::Image.new(media.id, params).perform
