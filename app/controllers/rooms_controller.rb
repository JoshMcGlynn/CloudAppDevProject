class RoomsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_hotel
  before_action :set_room, only: %i[show edit update destroy]

  #GET /hotels/:hotel_id/rooms.json
  def index
    rooms = @hotel.rooms.order(:number)
    render json: rooms
  end

  #GET /hotels/:hotel_id/rooms/:id.json
  def show
    render json: @room
  end

  #POST /hotels/:hotel_id/rooms
  def create
    room = @hotel.rooms.new(room_params)
    if room.save
      render json: room, status: :created
    else
      render json: {errors: room.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #PATCH/PUT /hotels/:hotel_id/rooms/:id
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: {errors: @room.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #DELETE /hotels/:hotel_id/rooms/:id
  def destroy
    @room.destroy
    render json: {message: "Room deleted"}
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_room
    @room = @hotel.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:number, :room_type, :price)
  end