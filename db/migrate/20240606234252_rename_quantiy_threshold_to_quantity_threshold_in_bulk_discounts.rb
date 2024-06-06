class RenameQuantiyThresholdToQuantityThresholdInBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
      rename_column :bulk_discounts, :quantiy_threshold, :quantity_threshold
  end
end
