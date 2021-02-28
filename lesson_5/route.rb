class Route
  include InstanceCounter
  
  attr_reader :stations, :begin_station, :end_station

  def initialize(begin_station, end_station)
    @begin_station = begin_station
    @end_station = end_station
    @stations = [@begin_station, @end_station]
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if station != (@begin_station && @end_station)
  end
end
