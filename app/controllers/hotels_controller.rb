class HotelsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_hotel, only: %i[show edit update destroy]

  #GET /hotels.json
  def index
    hotels = Hotel.all.order(:name)
    render json: hotels
  end

  #GET /hotels/:id.json
  def show
    render json: @hotel, include: :rooms
  end

  #POST /hotels
  def create
    hotel = Hotel.new(hotel_params)
    if hotel.save
      render json: hotel, status: :created
    else
      render json: {errors: hotel.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #PATCH/PUT /hotels/:id
  def update
    if @hotel.update(hotel_params)
      render json: @hotel
    else
      render json: {errors: @hotel.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #DELETE /hotels/:id
  def destroy
    @hotel.destroy
    render json: {message: "Hotel deleted"}
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def hotel_params
    params.require(:hotel).permit(:name, :location, :rating, :description)
  end
end