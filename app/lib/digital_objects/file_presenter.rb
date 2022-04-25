class DigitalObjects::FilePresenter

    def initialize(field)
        # set field data
        @field_data = field
        
        # get working media
        @archive = Media.where(filename: @field_data['filename'], media_type: :archive).first
        @working = Media.where(filename: filename, media_type: :working).first || nil
        @converted = Media.where(path: path_to_converted_file).first || nil
    end  

    # def field_data
    #     @field_data
    # end 

    def filename
        @archive.filename
    end

    def id
        @field_data['id']
    end

    def checksum
        @archive.checksum
    end

    def size
        @archive.size
    end

    def location
        # return location of archive file
        @archive.path.sub!('/home/mfcs/data', '')
    end

    def original_media_id
        # return id of working media
        @working.id
    end

    def path_to_converted_file
        # remove filename from path
        full_file_path = @field_data['path'].sub!(filename, '')

        # change path to /data/converted
        converted_file_path = full_file_path.sub!('archives', 'conversions')

        # return location of the converted file
        if File.exist?(converted_file_path)
          return converted_file_path + Dir.entries(converted_file_path).first
        end
        nil
    end

    def converted_media_id
        @converted.id if @converted
    end    

    def thumbnail
        # remove filename from path
        full_file_path = @field_data['path'].sub!(filename, '')

        # change path to /data/converted/thumbnail
        converted_file_path = full_file_path.sub!('archives', 'conversions/thumbnail')

        if File.directory?(converted_file_path)
            # return location of the converted file
            converted_file_path + Dir.entries(converted_file_path).first
        else
            # return location of the converted file
            converted_file_path
        end
    end

    def thumbnail_media_id
        # remove filename from path
        full_file_path = @field_data['path'].sub!(filename, '')

        # change path to /data/converted
        thumbnail_file_path = full_file_path.sub!('archives', 'conversions/thumbnail')

        # return location of the converted file
        thumbnail_media = Media.where(filename: Dir.entries(thumbnail_file_path).first).first
        thumbnail_media.id
    end 

    def download_links
        list_array = []
        list_array  <<  { url: "/media/original/#{self.id}", label: "Original" }
        list_array  <<  { url: "/media/converted/#{@converted.id}", label: field_label } if @converted  
        # download thumbnail
                   
    end

    def preview_links
        list_array = []
        # list_array  <<  { url: "/media/original/#{@working.id}", label: "Original" } if @working.id.present?

        list_array  <<  create_preview_link if @converted 
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
        FileInspector::Type.new(@field_data['mime_type']).file_type

        case FileInspector::Type.new(@field_data['mime_type']).file_type
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
        if @converted.image? 
          "Converted Image"
        elsif @converted.sound?
           "Converted Audio"
        elsif @converted.video?
           "Converted Video"
        elsif @converted.pdf?
           "Converted Pdf"
        elsif @converted.text?
           "Converted Text or Document"
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
  