class Train
  attr_accessor :speed, :current_station, :next_station, :last_station, :route
  attr_reader  :num_carriage, :number, :type

  def initialize(number, type, num_carriage)
    @number = number
    @type = type
    @num_carriage = num_carriage
    self.speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_carriage
    return puts "Поезд движется, невозможно прицепить вагон!" if self.speed != 0
    @num_carriage += 1
  end

  def drop_carriage
    return puts "Поезд движется, невозможно отцепить вагон!" if self.speed != 0
    @num_carriage -= 1
  end

  def route_train(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
    @next_station = @route.stations[1]
  end

  def next_route
    station_index = self.route.stations.index(self.current_station)
    if station_index != (@route.stations.size - 1)
      @current_station.send_train(self)
      @current_station = @route.stations[station_index + 1]
      @route.stations.last ? @next_station = @route.stations[station_index + 2] : nil
      @last_station = @route.stations[station_index]
      @current_station.take_train(self)
    else
       puts "Это последняя станция. Поезд прибыл!"
    end
  end

  def last_route
    station_index = self.route.stations.index(self.current_station)
    if (station_index - 1) >= 0
      @current_station.send_train(self)
      @current_station = @route.stations[station_index - 1]
      @next_station = @route.stations[station_index]
      (station_index - 1) > 0 ? @last_station = @route.stations[station_index - 2] : nil
      @current_station.take_train(self)
    else
       puts "Это первая станция!"
    end
  end
end
