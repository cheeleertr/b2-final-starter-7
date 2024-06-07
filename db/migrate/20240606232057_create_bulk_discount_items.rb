class CreateBulkDiscountItems < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discount_items do |t|
      t.references :bulk_discount, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
