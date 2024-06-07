require "rails_helper"

describe "merchant bulk_discounts index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percent_discount: 10)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percent_discount: 15)

    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 20, percent_discount: 20)
  end
  #US1
  it "for each bulk discount I can see each of it's attr and each has a link to its merchant bulk discount show page" do
    visit merchant_bulk_discounts_path(@merchant1)

    within "#discount_#{@bulk_discount1.id}" do
      expect(page).to have_link("#{@bulk_discount1.id}", href: merchant_bulk_discount_path(@merchant1, @bulk_discount1))
      expect(page).to have_content("Discount: ##{@bulk_discount1.id}, Quantity Threshold: #{@bulk_discount1.quantity_threshold}, Percent Discount: #{@bulk_discount1.percent_discount}")
    end
    within "#discount_#{@bulk_discount2.id}" do
      expect(page).to have_link("#{@bulk_discount2.id}", href: merchant_bulk_discount_path(@merchant1, @bulk_discount2))
      expect(page).to have_content("Discount: ##{@bulk_discount2.id}, Quantity Threshold: #{@bulk_discount2.quantity_threshold}, Percent Discount: #{@bulk_discount2.percent_discount}")
    end

    expect(page).to_not have_link("#{@bulk_discount3.id}", href: merchant_bulk_discount_path(@merchant1, @bulk_discount3))
    expect(page).to_not have_content("Discount: ##{@bulk_discount3.id}, Quantity Threshold: #{@bulk_discount3.quantity_threshold}, Percent Discount: #{@bulk_discount3.percent_discount}")
  end
  #US2
  it "has a link to create a new discount" do
    visit merchant_bulk_discounts_path(@merchant1)

    expect(page).to have_link("Create New Discount")

    click_link "Create New Discount"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
  end
  #US3
  it "can delete a bulk discount with a button next to it" do
    visit merchant_bulk_discounts_path(@merchant1)

    expect(page).to have_link("#{@bulk_discount1.id}", href: merchant_bulk_discount_path(@merchant1, @bulk_discount1))
    expect(page).to have_content("Discount: ##{@bulk_discount1.id}, Quantity Threshold: #{@bulk_discount1.quantity_threshold}, Percent Discount: #{@bulk_discount1.percent_discount}")

    within "#discount_#{@bulk_discount1.id}" do
      click_button "Delete #{@bulk_discount1}"
    end

    expect(page).to_not have_link("#{@bulk_discount1.id}", href: merchant_bulk_discount_path(@merchant1, @bulk_discount1))
    expect(page).to_not have_content("Discount: ##{@bulk_discount1.id}, Quantity Threshold: #{@bulk_discount1.quantity_threshold}, Percent Discount: #{@bulk_discount1.percent_discount}")

    expect(page).to_not have
  end
end
