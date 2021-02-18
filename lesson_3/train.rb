class Train
  attr_accessor :speed, :current_station, :route
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
  end

  def next_route
    if @current_station != @route.end_station
      @current_station.send_train(self)
      @current_station = @route.stations[current_index + 1]
      @current_station.take_train(self)
    else
       @next_station = nil
       puts "Это последняя станция. Поезд прибыл!"
    end
  end

  def last_route
    if @current_station != @route.begin_station
      @current_station.send_train(self)
      @current_station = @route.stations[current_index - 1]
      @current_station.take_train(self)
    else
       @last_station = nil
       puts "Это первая станция!"
    end
  end

  def next_station
    @current_station != @route.end_station ? @route.stations[current_index + 1] : nil
  end

  def last_station
    @current_station == @route.begin_station ? nil : @route.stations[current_index - 1]
  end

  private

  def current_index
    self.route.stations.index(self.current_station)
  end



end
