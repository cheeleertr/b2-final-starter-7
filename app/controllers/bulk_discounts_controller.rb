class BulkDiscountsController < ApplicationController
  before_action :find_bulk_discount_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:new, :create, :index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_bulk_discount_params)
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
    BulkDiscount.create!(quantity_threshold: params[:quantity_threshold],
                percent_discount: params[:percent_discount],
                merchant: @merchant)
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