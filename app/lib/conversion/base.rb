class Conversion::Base
  include Conversion::Params
  # base init method
  def initialize(item_id)
    @item = Item.find(item_id)
  end
end
