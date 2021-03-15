# frozen_string_literal: true

class PassengerCarriage < Carriage
  include CarriageSeat

  def initialize(count_seat)
    @count_seat = count_seat
    @take_seats = 0
    validate!
    super(:passenger)
  end
end
