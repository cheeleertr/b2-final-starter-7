class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percent_discount,
                        :merchant_id

  belongs_to :merchant
end