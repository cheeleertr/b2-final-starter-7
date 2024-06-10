class BulkDiscountsController < ApplicationController
  before_action :find_bulk_discount_and_merchant, only: [:show, :edit, :update, :destroy]
  before_action :find_merchant, only: [:new, :create, :index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      flash.notice = "Succesfully Updated bulk_discount Info!"
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash.notice = "All fields must be completed, get your act together."
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def new
  end

  def create
    discount = BulkDiscount.new(quantity_threshold: params[:quantity_threshold],
                percent_discount: params[:percent_discount],
                merchant: @merchant)
    if discount.save
      flash.notice = 'Discount Has Been Created!'
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.notice = "All fields must be completed, get your act together."
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity_threshold, :percent_discount, :merchant_id)
  end

  def find_bulk_discount_and_merchant
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
