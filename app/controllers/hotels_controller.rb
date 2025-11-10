class HotelsController < ApplicationController
  before_action :set_hotel, only: %i[show edit update destroy]

  def index
    @hotels = Hotel.all
  end

  def show
  end

  def new
    @hotel = Hotel.new
  end

  def edit
  end

  def create
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      redirect_to @hotel, notice: "Hotel successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @hotel.update(hotel_params)
      redirect_to @hotel, notice: "Hotel successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hotel.destroy
    redirect_to hotels_url, notice: "Hotel deleted."
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def hotel_params
    params.require(:hotel).permit(:name, :location, :rating, :description)
  end
end