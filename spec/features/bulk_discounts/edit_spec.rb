require "rails_helper"

describe "merchant bulk_discounts index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @bulk_discount_1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percent_discount: 10)
    @bulk_discount_2 = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percent_discount: 15)
  end
  #US5
  it "can update bulk_discount info" do
    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)

    expect(page).to have_content("Discount: ##{@bulk_discount_1.id}")
    expect(page).to have_content("Quantity Threshold: 10")
    expect(page).to have_content("Percent Discount: 10")
    
    click_link "Update Discount"

    fill_in "Quantity threshold", with: 25
    fill_in "Percent discount", with: 30

    click_button "Submit"

    expect(page).to have_content("Discount: ##{@bulk_discount_1.id}")
    expect(page).to have_content("Quantity Threshold: 25")
    expect(page).to have_content("Percent Discount: 30")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}")
  end

  it "shows a flash message if not all sections are filled in" do
    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1)

    fill_in "Quantity threshold", with: ""
    fill_in "Percent discount", with: ""

    click_button "Submit"
    
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
    expect(page).to have_content("All fields must be completed, get your act together.")
  end
end