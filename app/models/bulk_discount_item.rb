class BulkDiscountItem < ApplicationRecord
  validates_presence_of :item_id,
                        :bulk_discount_id

  belongs_to :bulk_discount
  belongs_to :item
end