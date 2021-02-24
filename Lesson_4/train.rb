class Train
  attr_accessor :speed
  attr_reader  :number, :type, :carriage, :current_station, :route

  def initialize(number, type)
    @number = number
    @type = type
    @carriage = []
    self.speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    return puts "Поезд движется, невозможно прицепить вагон!" if self.speed != 0
    @carriage << carriage if self.type == carriage.type
  end

  def drop_carriage
    return puts "Поезд движется, невозможно отцепить вагон!" if self.speed != 0
    @carriage.pop
  end

  def route_train(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
  end

  def next_route
    return unless next_station
    @current_station.send_train(self)
    @current_station = next_station
    @current_station.take_train(self)
  end

  def last_route
    return unless last_station
    @current_station.send_train(self)
    @current_station = last_station
    @current_station.take_train(self)
  end

  def next_station
    @route.stations[current_index + 1] if @current_station != @route.end_station
  end

  def last_station
    @route.stations[current_index - 1] if @current_station != @route.begin_station
  end

  def train_passenger?
    self.type == :passenger
  end

  private

  # данные атрибуты должны изменяться только внури класса.
  attr_writer :current_station, :route

  # метод возвращает индекс текущий стации в массиве маршрута
  def current_index
    self.route.stations.index(self.current_station)
  end



end
