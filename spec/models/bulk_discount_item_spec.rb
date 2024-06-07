require 'rails_helper'

RSpec.describe BulkDiscountItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :bulk_discount_id }
    it { should validate_presence_of :item_id }
  end
  describe "relationships" do
    it { should belong_to :bulk_discount }
    it { should belong_to :item }
  end
end