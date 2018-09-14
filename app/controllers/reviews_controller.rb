class ReviewsController < ApplicationController
  def create
    @product = Product.includes(reviews: [:user]).find_by(id: params[:product_id])
    # @product.reviews.new(review_params)
    @review = @product.reviews.create(review_params)
    @review.user = current_user

    if @review.save
      redirect_to product_path(@product)
    else
      render 'show'
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :description,
      :rating
    )
  end
end
