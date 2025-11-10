class RoomsController < ApplicationController
  before_action :set_hotel
  before_action :set_room, only: %i[show edit update destroy]

  def index
    @rooms = @hotel.rooms
  end

  def show
  end

  def new
    @room = @hotel.rooms.build
  end

  def edit
  end

  def create
    @room = @hotel.rooms.build(room_params)
    if @room.save
      redirect_to hotel_rooms_path(@hotel), notice: "Room successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @room.update(room_params)
      redirect_to hotel_rooms_path(@hotel), notice: "Room successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    redirect_to hotel_rooms_path(@hotel), notice: "Room deleted."
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
end