#!/bin/env ruby

class RunConversions
  require 'json'
  require 'active_support/inflector' 

  def initialize
    self.perform
  end  

  def perform
    medias = Media.where(media_type: :archive)

    puts "Starting Conversions"
    puts medias.count.to_s + " archive media"

    medias = Media.where(media_type: :working)
    puts medias.count.to_s + " working media"

    medias.each do |media|
      puts "Processing #{media.id}"
      puts "Form Id #{media.form_id}"

      item = Item.find(media.item_id)
      # if not File.directory?(item.conversion_path)
      #   puts "Conversion path for #{item.id} does not exist: #{item.conversion_path}"
      #   FileUtils.mkdir_p(item.conversion_path) unless File.directory?(item.conversion_path)
      # end

      # puts "Running Conversions"
      # #ConvertingFileJob.perform_later(media.id)

      form = Form.where(id: item.form_id).first
      puts "Organized Hash for #{media.fieldname}"
      puts form.organized_hash[media.fieldname].inspect

      base = Conversion::Actor.new(media.id, form.organized_hash[media.fieldname])
      base.perform

      sleep(rand(1..2))
    end
  end
end

RunConversions.new