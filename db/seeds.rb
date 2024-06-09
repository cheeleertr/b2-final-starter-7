# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Rake::Task["csv_load:all"].invoke

@merchant1 = Merchant.create!(name: 'Hair Care')
@item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
@item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
@item_9 = Item.create!(name: "Dragonfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
@customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
@invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
@ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
@ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
@ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_9.id, quantity: 5, unit_price: 10, status: 1)
@discount1 = @merchant1.bulk_discounts.create!(percent_discount: 20, quantity_threshold: 5)
@merchant2 = Merchant.create!(name: 'Hair Dont Care')
@item_2 = Item.create!(name: "Shampee", description: "This doesn't washes your hair", unit_price: 10, merchant_id: @merchant2.id, status: 1)
@ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 10, status: 2)
@discount2 = @merchant1.bulk_discounts.create!(percent_discount: 30, quantity_threshold: 9)