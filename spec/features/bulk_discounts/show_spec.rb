require "rails_helper"

describe "merchant bulk_discounts show" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @bulk_discount_1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percent_discount: 10)
    @bulk_discount_2 = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percent_discount: 15)
  end

  #US4
  it "can see all the bulk_discounts attributes including name, description, and selling price" do
    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)

    expect(page).to have_content("Discount: ##{@bulk_discount_1.id}")
    expect(page).to have_content("Quantity Threshold: #{@bulk_discount_1.quantity_threshold}")
    expect(page).to have_content("Percent Discount: #{@bulk_discount_1.percent_discount}")

    expect(page).to_not have_content("Discount: #{@bulk_discount_2.id}")
  end

  #US5
  it "has a link to update bulk_discount info" do
    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)

    expect(page).to have_link("Update Discount")
    click_link "Update Discount"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}/edit")
  end
end