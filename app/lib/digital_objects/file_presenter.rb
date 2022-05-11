class DigitalObjects::FilePresenter
    def initialize(file)
        @file = file.freeze
        @working = Media.where(filename: @file['filename'], media_type: :working).first
        #@converted = Media.where(path: converted_file_location, media_type: :converted).first unless converted_file_location.nil?
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

    def data
        @file.read
    end

    def size
        @file['size']
    end

    def converted?
        # does converted file exist?
        @converted.nil? ? false : true
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
        archive_path.sub!('/home/mfcs/data', '')
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
        # return id of converted media
        if converted?
            @converted.id
        else
            nil
        end
    end

    def full_file_path
        # return full path to archive file
        path = @file['path']
        path.sub!(filename, '')
    end

    #def converted_file_path
        # return full path to converted file
    #    @file['path'].sub!(filename, '').sub!('archives', 'conversions')

        #@file['path'].sub!(filename, '').sub!('archives', 'conversions')
        # "/home/mfcs/data/114/2defbb0d/9f26/461b/a3c2/e134c60a09d6/conversions/"
    #end

    def converted_file_location
        converted_path = @file['path'].sub!(filename, '').sub!('archives', 'conversions')
        # return location of the converted file
        if File.exist?(converted_path)
          return converted_path + Dir.entries(converted_path).find { |f| f.include?(File.basename(filename, ".*")) }
        else
            return nil
        end
    end  

    def thumbnail
        # change path to /data/converted/thumbnail
        thumbnail_file_path = full_file_path.sub!('archives', 'conversions/thumbnail')


        # return location of the converted file
        if File.exist?(converted_file_path)
            return converted_file_path + Dir.entries(thumbnail_file_path).find { |f| f.include?(File.basename(filename, ".*")) }
        end
    end

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
        #list_array  <<  { url: "/media/converted/#{@converted.id}", label: field_label } if converted?
        # download thumbnail
                   
    end

    def preview_links
        list_array = []
        list_array  <<  { url: "/media/original/#{@working.id}", label: "Original" } if @working.id.present?
        #list_array  <<  create_preview_link
    end

    def create_preview_link
        if @converted.image? 
            { url: "/media/image/#{@converted.id}", label: "Converted Image" }
        elsif @converted.sound?
            { url: "/media/audio/#{@converted.id}", label: "Converted Audio" }
        elsif @converted.video?
            { url: "/media/video/#{@converted.id}", label: "Converted Video" }
        elsif @converted.pdf?
            { url: "/media/pdf/#{@converted.id}", label: "Converted Pdf" }
        elsif @converted.text?
            { url: "/media/text/#{@converted.id}", label: "Converted Text or Document" }
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

    # def field_label
    #     if @converted.image? 
    #       "Converted Image"
    #     elsif @converted.sound?
    #        "Converted Audio"
    #     elsif @converted.video?
    #        "Converted Video"
    #     elsif @converted.pdf?
    #        "Converted Pdf"
    #     elsif @converted.text?
    #        "Converted Text or Document"
    #     end  
    # end

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
  