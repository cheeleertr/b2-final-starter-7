class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def merchant_discounted_revenue(merchant_id)
    @merchant_id = merchant_id

    @highest_discounts = self.invoice_items
      .joins(item: { merchant: :bulk_discounts })
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold and bulk_discounts.merchant_id = ?', @merchant_id)
      .select('invoice_items.id as invoice_item_id, max(bulk_discounts.percent_discount) as max_discount, merchants.id as merchants_id')
      .group('invoice_items.id', "merchants.id, items.id")

    self.invoice_items
      .joins(:item)
      .joins("left join (#{@highest_discounts.to_sql}) as highest_discounts on highest_discounts.invoice_item_id = invoice_items.id")
    #ask how is alias items_invoice_items
      .where("items_invoice_items.merchant_id = ?", @merchant_id)
      .group('invoice_items.invoice_id')
      .pluck(
        Arel.sql(
          'sum((case when highest_discounts.max_discount is null then 1 else (1 - highest_discounts.max_discount / 100.0) end) * invoice_items.unit_price * invoice_items.quantity)'
        ))
      .first
  end

  def total_discounted_revenue
    @highest_discounts = self.invoice_items
      .joins(item: { merchant: :bulk_discounts })
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .select('invoice_items.id as invoice_item_id, max(bulk_discounts.percent_discount) as max_discount')
      .group('invoice_items.id')
      
    invoice_items.joins("left join (#{@highest_discounts.to_sql}) as highest_discounts on highest_discounts.invoice_item_id = invoice_items.id")
      .group('invoice_items.invoice_id')
      .pluck(
        Arel.sql(
          'sum((case when highest_discounts.max_discount is null then 1 else (1 - highest_discounts.max_discount / 100.0) end) * invoice_items.unit_price * invoice_items.quantity)'
        ))
      .first
    # pry
    #sql that works
    # SELECT invoice_items.invoice_id, SUM((CASE WHEN highest_discounts.max_discount IS NULL THEN 100 ELSE (100 - highest_discounts.max_discount) end) * invoice_items.unit_price * invoice_items.quantity / 100) AS total_revenue
    # FROM "invoice_items" 
    # LEFT JOIN (
    # 	SELECT invoice_items.id as invoice_item_id, invoice_items.item_id, max(bulk_discounts.percent_discount) as max_discount
    # 	FROM "invoice_items" 
    # 	INNER JOIN "items" ON "items"."id" = "invoice_items"."item_id" 
    # 	INNER JOIN "merchants" ON "merchants"."id" = "items"."merchant_id" 
    # 	INNER JOIN "bulk_discounts" ON "bulk_discounts"."merchant_id" = "merchants"."id" 
    # 	WHERE ("invoice_items"."invoice_id" = 1 AND invoice_items.quantity >= bulk_discounts.quantity_threshold
    # 	) 
    # 	GROUP BY "invoice_items"."id") 
    # 	AS highest_discounts 
    # 	ON highest_discounts.invoice_item_id = invoice_items.id 
    # WHERE "invoice_items"."invoice_id" = 1 
    # GROUP BY invoice_items.invoice_id

        # workin base returns hash
    # invoice_items.joins(item: {merchant: :bulk_discounts}).select("invoice_items.*, bulk_discounts.*, merchants.id").where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group("invoice_id")
    # .sum("invoice_items.unit_price * bulk_discounts.percent_discount * quantity / 100")
    #test query

    # invoice_items.joins(item: {merchant: :bulk_discounts}).select("invoice_items.*, bulk_discounts.*, merchants.id").where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group("invoice_id").sum("invoice_items.unit_price * bulk_discounts.percent_discount * quantity / 100")

    #possibly working return array of invoiceitem
    # @sub_table = invoice_items.joins(item: {merchant: :bulk_discounts}).select("invoice_items.*, max(bulk_discounts.percent_discount) as max_discount, max(bulk_discounts.quantity_threshold) as max_threshold, sum(invoice_items.unit_price * quantity) as base_revenue").where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group("invoice_id, invoice_items.id")
  end
end
