class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def highest_discount
    item.merchant.bulk_discounts
    .joins(merchant: {items: :invoice_items})
    .where("quantity >= bulk_discounts.quantity_threshold and invoice_items.id = ?", self.id, )
    .order(percent_discount: :desc)
    .first
  end
end
