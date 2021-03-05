class CargoCarriage < Carriage
  include CarriageSeat

  def initialize(count_seat)
    @count_seat = count_seat
    @take_seats = 0
    validate!
    super(:cargo)
  end
end
