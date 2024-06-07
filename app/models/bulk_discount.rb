class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percent_discount,
                        :merchant_id

  belongs_to :merchant
  has_many :bulk_discount_items
  has_many :items, through: :bulk_discount_items
end