class DigitalObjects::FilePresenter
    def initialize(file)
        @file = file.freeze
        @working = Media.where(filename: @file['filename'], media_type: :working).first
        @item = Item.find(@file['item_id'])
        @converted = Media.where(filename: converted_filename, media_type: :converted).first
    end

    def filename
        @file['filename']
    end

    def archive_path
        @file['path']
    end

    def checksum
        @file['checksum']
    end

    def size
        @file['size']
    end

    def converted?
        return false if @converted.nil?
        return true if @converted
    end

    # def field_data
    #     @field_data
    # end 

    # def id
    #     @field_data['id']
    # end

    # def checksum
    #     @archive.checksum
    # end

    # def size
    #     @archive.size
    # end

    def location
        # return location of archive file without full path
        archive_path.sub!('/home/mfcs', '')
    end

    # def archive_media_id
    #     # return id of archive media
    #     @archive.id
    # end

    # def working_media_id
    #     # return id of working media
    #     @working.id
    # end

    def converted_media_id
        @converted = Media.where(filename: converted_filename).first
        @converted.id
    end

    def full_file_path
        # return full path to archive file
        path = @file['path']
        path.sub!(filename, '')
    end

    def converted_file_path
        # return full path to converted file
        @item.conversion_path.to_s
    end

    def converted_filename
        # return array of converted files
        if converted_file_path != nil
            file = Dir.glob(converted_file_path + "/*").find { |f| f.include?(File.basename(filename, ".*")) }
            return File.basename(file) unless file.nil?
        end
        ""
    end

    # check the converted_file_path to see if it exists and is not empty
    def converted_file_exists?
        File.exist?(converted_file_path) && File.size(converted_file_path) > 0
    end

    def converted_file_location
        # return location of the converted file
        if File.exist?(converted_file_path)
          return Dir.glob(converted_file_path + "/*").find { |f| f.include?(File.basename(filename, ".*")) }
        end
        return nil
    end  

    # def thumbnail
    #     # change path to /data/converted/thumbnail
    #     thumbnail_file_path = full_file_path.sub!('archives', 'conversions/thumbnail')

    #     # return location of the converted file
    #     if File.exist?(thumbnail_file_path)
    #         return thumbnail_file_path + Dir.entries(thumbnail_file_path).find { |f| f.include?(File.basename(filename, ".*")) }
    #     end
    # end

    # def thumbnail_media_id
    #     # change path to /data/converted
    #     thumbnail_file_path = full_file_path.sub!('archives', 'conversions/thumbnail')

    #     # return location of the converted file
    #     thumbnail_media = Media.where(filename: Dir.entries(thumbnail_file_path).first).first
    #     thumbnail_media.id
    # end 

    def download_links
        list_array = []
        list_array  <<  { url: "/media/original/#{@working.id}", label: "Original" }
        list_array  <<  { url: "/media/original/#{converted_media_id}", label: field_label } if converted_file_exists?
        # list_array  <<  { url: "/media/converted/#{@converted.id}", label: field_label } if converted_file_exists?
        # download thumbnail                  
    end

    def preview_links
        list_array = []
        list_array  <<  { url: "/media/original/#{@working.id}", label: "Original" }
        # list_array  <<  { url: "/media/original/#{converted_media_id}", label: field_label } if converted_file_exists?
        list_array  <<  create_preview_link if converted_file_exists?
    end

    def create_preview_link
        if @converted.image? 
            { url: "/media/image/#{@converted.id}", label: field_label }
        elsif @converted.sound?
            { url: "/media/audio/#{@converted.id}", label: field_label }
        elsif @converted.video?
            { url: "/media/video/#{@converted.id}", label: field_label }
        elsif @converted.pdf?
            { url: "/media/pdf/#{@converted.id}", label: field_label }
        elsif @converted.text?
            { url: "/media/text/#{@converted.id}", label: field_label }
        end 
    end
    
    def fa_icon
        # return font awesome icon for file type
        case FileInspector::Type.new(@file['mime_type']).file_type
        when "Image"
            "fa fa-file-image"
        when "Audio"
            "fa fa-file-audio"
        when "Video"
            "fa fa-file-video"
        when "Pdf"
            "fa fa-file-pdf"
        when "Text"
            "fa fa-file-text"
        else
            "fa fa-file"
        end      
    end 

    def field_label
        # return field label for file type
        case FileInspector::Type.new(@file['mime_type']).file_type
        when "Image"
            "Converted Image"
        when "Audio"
            "Converted Audio"
        when "Video"
            "Converted Video"
        when "Pdf"
            "Converted Pdf"
        when "Text"
            "Converted Text or Document"
        else
            "Unknown"
        end      
    end 

    def route_media_path
         # return field label for file type
         case FileInspector::Type.new(@file['mime_type']).file_type
         when "Image"
             "image"
         when "Audio"
             "audio"
         when "Video"
             "video"
         when "Pdf"
             "pdf"
         else
             "Unknown"
         end   
    end       

    # def preview_links
    #     list_array = []
    #     # list_array  <<  { url: "/media/original/#{@working.id}", label: "Original" } if @working.id.present?

    #     if @converted 
    #         if @converted.image? 
    #             list_array  <<  { url: "/media/image/#{@converted.id}", label: "Converted Image" }
    #         elsif @converted.sound?
    #             list_array  <<  { url: "/media/audio/#{@converted.id}", label: "Converted Audio" }
    #         elsif @converted.video?
    #             list_array  <<  { url: "/media/video/#{@converted.id}", label: "Converted Video" }
    #         elsif @converted.pdf?
    #             list_array  <<  { url: "/media/image/#{@converted.id}", label: "Converted Pdf" }
    #         elsif @converted.text?
    #             list_array  <<  { url: "/media/document/#{@converted.id}", label: "Converted Text or Document" }
    #         end  
    #         list_array  <<  { url: "/media/document/#{@converted.id}", label: "Converted Text or Document" }          
    #     end 
    # end
  
end
  