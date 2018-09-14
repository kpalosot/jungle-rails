class ReviewsController < ApplicationController

  before_filter :is_logged_in?
  # before_action :set_product

  def create
    @product = Product.includes(reviews: [:user]).find_by(id: params[:product_id])
    @review = @product.reviews.create(review_params)
    @review.user = current_user

    if @review.save
      redirect_to product_path(@product)
    else
      render 'show'
    end
  end

  def destroy
    @product = Product.includes(reviews: [:user]).find_by(id: params[:product_id])
    @review = @product.reviews.find_by(id: params[:id])
    @review.destroy
    redirect_to @product

  end

  private

  # def set_product
  #   @product = Product.includes(reviews: [:user]).find_by(id: params[:product_id])
  # end

  def is_logged_in?
    defined? current_user
  end

  def review_params
    params.require(:review).permit(
      :description,
      :rating
    )
  end
end
