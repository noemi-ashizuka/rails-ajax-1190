class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @restaurants = policy_scope(Restaurant)
    @markers = Restaurant.geocoded.map do |restaurant|
      {
        lat: restaurant.latitude,
        lng: restaurant.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { restaurant: restaurant}),
        marker_html: render_to_string(partial: "marker", locals: { restaurant: restaurant })
      }
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    authorize(@restaurant)
  end

  def new
    # This empty instance is for the form builder
    @restaurant = Restaurant.new
    authorize(@restaurant)
  end

  # this action DOES NOT have a view
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize(@restaurant)

    if @restaurant.save
      redirect_to restaurant_path(@restaurant)
    else
      # display the form page again
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # this is for the form builder
    @restaurant = Restaurant.find(params[:id])
    authorize(@restaurant)
  end

  # this action DOES NOT have a view
  def update
    @restaurant = Restaurant.find(params[:id])
    authorize(@restaurant)
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant)
    else
      # display the form page again
      render :edit, status: :unprocessable_entity
    end
  end

  # this action DOES NOT have a view
  def destroy
    @restaurant = Restaurant.find(params[:id])
    authorize(@restaurant)
    @restaurant.destroy
    # status is for turbo
    redirect_to restaurants_path, status: :see_other
  end

  private

  # strong params -> white listing the info coming from the form
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :rating)
  end
end
