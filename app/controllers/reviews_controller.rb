class ReviewsController < ApplicationController
  def new
    # what does the form need? review AND restaurant
    @review = Review.new
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize @review
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new(review_params)
    # i have to give the review the restaurant
    @review.restaurant = @restaurant
    authorize @review
    respond_to do |format|
      if @review.save
        format.html { redirect_to restaurant_path(@restaurant) }
        format.json do 
          render json: {
            review_html: render_to_string(partial: "reviews/review", formats: :html, locals: { review: @review }),
            form_html: render_to_string(partial: "reviews/new", formats: :html, locals: { restaurant: @review.restaurant, review: Review.new }),
        }.to_json
        end
      else
        # if doesnt save, show the 'new' form again
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: {
            form_html: render_to_string(partial: "reviews/new", formats: :html, locals: { restaurant: @review.restaurant, review: @review }),
        }.to_json
        end
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    authorize @review
    redirect_to restaurant_path(@review.restaurant), status: :see_other
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end
end
