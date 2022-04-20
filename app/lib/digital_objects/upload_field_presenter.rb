class DigitalObjects::UploadFieldPresenter

    def initialize(item_id)
        @item = Item.find(item_id)
    end  
  
    def uploaded_files?(field_name)
      @item.data.each do |key, value|
        if key.eql?(field_name)
            return true
        end
      end
      false
    end
end
  