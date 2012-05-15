module ProductMethods
  extend ActiveSupport::Concern
  
  # SKU generation helper
  #
  # @return [String] The generated SKU
  def generate_sku
    # Get last product only selecting id
    last_item = self.class.select(:id).order('id DESC').first
    # Generate SKU from the last product id we got, or appending "1" if there's no product
    "#{self.class.to_s.underscore}-#{last_item ? (last_item.id + 1).to_s : '1'}"
  end
  
end