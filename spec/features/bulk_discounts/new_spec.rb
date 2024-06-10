require "rails_helper"

describe "merchant bulk discount new page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percent_discount: 10)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percent_discount: 15)

    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 20, percent_discount: 20)
  end
  #US2
  it "has a link to create a new item" do
    visit new_merchant_bulk_discount_path(@merchant1)
    
    fill_in "Quantity threshold", with: 25
    fill_in "Percent discount", with: 30
    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    bulk_discount4 = @merchant1.bulk_discounts.last
    
    within "#discount_#{bulk_discount4.id}" do
      expect(page).to have_link("#{bulk_discount4.id}", href: merchant_bulk_discount_path(@merchant1, bulk_discount4))
      expect(page).to have_content("Discount: ##{bulk_discount4.id}, Quantity Threshold: 25, Percent Discount: 30")
    end
  end

  it "shows a flash message if not all sections are filled in" do
    visit new_merchant_bulk_discount_path(@merchant1)

    fill_in "Quantity threshold", with: ""
    fill_in "Percent discount", with: ""

    click_button "Submit"
    
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_content("All fields must be completed, get your act together.")
  end
end