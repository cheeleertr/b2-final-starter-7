class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percent_discount
      t.integer :quantiy_threshold
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
