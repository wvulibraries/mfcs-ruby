class DigitalObjects::MetadataPresenter

    def initialize(field_name, item_ids)
        @field_name = field_name

        # insure we have an array of item_ids
        @item_ids = item_ids.is_a?(Array) ? item_ids : [item_ids]
    end

    def data
        meta_data = []
        # loop over item_ids and get the associated metadata
        @item_ids.map do |item_id|
            if item_id.eql?("")
                meta_data << "Item not found"
            else
                item = Item.find(item_id)
                # get the metadata field
                meta_data << item.data[@field_name]
            end
        end
        if meta_data.count == 1
            return meta_data.first
        else
            return meta_data
        end
    end
end