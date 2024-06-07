require "rails_helper"

RSpec.describe "merchant index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")
  end

  it "returns list of all merchants names as a link to its dashboard index" do
    visit "/merchants" do

      expect(page).to have content("Name: #{@merchant1.name}")
      expect(page).to have content("Name: #{@merchant2.name}")
      expect(page).to have link("#{@merchant1.name}", href: "/merchants/#{@merchant1.id}/dashboard")
      expect(page).to have link("#{@merchant2.name}", href: "/merchants/#{@merchant2.id}/dashboard")
    end
  end
end