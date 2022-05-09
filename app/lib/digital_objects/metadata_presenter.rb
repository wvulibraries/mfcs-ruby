class DigitalObjects::MetadataPresenter

    def initialize(item_ids)
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
                form = Form.find(item.form_id)

                # get the metadata field
                meta_data << item.data[form.object_title_field]
            end
        end
        meta_data
    end
end