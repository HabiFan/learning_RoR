class Route
  attr_reader :stations, :begin_station, :end_station
  def initialize(begin_station, end_station)
    @begin_station = begin_station
    @end_station = end_station
    @stations = []
    @stations << @begin_station << @end_station
  end

  def add_station(station)
    @stations[-1, 0] = station
  end

  def delete_station(station)
    @stations.delete(station) if station != (@begin_station && @end_station)
  end
end
