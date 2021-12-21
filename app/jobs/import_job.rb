class ImportJob < ApplicationJob
  queue_as :default

  def perform(file)
    @hash = JSON.parse(File.read(file))

    # only import objects
    if @hash.present? && Item.where(id: @hash['ID']).count == 0
      # rename timestamps and convert format
      @hash['created_at'] = Time.at(@hash.delete('createTime').to_f) if @hash['createTime']
      @hash['updated_at'] = Time.at(@hash.delete('modifiedTime').to_f) if @hash['modifiedTime']

      # delete items
      @hash.delete('parentID')
      @hash.delete('defaultProject')
      # @hash.delete('modifiedTime')
      # @hash.delete('createTime')
      # @hash.delete('modifiedBy')
      # @hash.delete('createdBy')
      @hash.delete('objectProject')

      # save old file info
      files_hash = {}
      @hash['data'].each do |key, value|
        if field_has_files?(value)
          files_hash[key] = value
          @hash['data'].delete(key)
        end
      end

      array = @hash.keys
      array.each { |key| update_key(key) }

      # create items
      create_item(@hash)

      # queue job to process files
      ProcessFilesJob.perform_later(@hash['id'], files_hash) unless files_hash.empty?
    end
  end

  private

  def create_item(hash_values)
    i = Item.new(hash_values)
    i.record_timestamps = false
    i.save(validate: false)
  rescue StandardError => e
    # puts "Rescued: #{e.inspect}"
    # abort
    logger.error e.message
    logger.error e.backtrace.join("\n")
  end

  # string contains files key
  def field_has_files?(obj)
    obj.has_key?('files')
  rescue StandardError
    false
  end

  def update_key(name)
    @hash[name.to_s.underscore] = @hash.delete(name)
  end
end
