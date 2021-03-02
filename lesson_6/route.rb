class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :begin_station, :end_station

  def initialize(begin_station, end_station)
    @begin_station = begin_station
    @end_station = end_station
    validate!
    @stations = [@begin_station, @end_station]
    register_instance
  end

  def add_station(station)
    raise "Не верный формат добавляемой станции!" unless station.is_a?(Station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if station != (@begin_station && @end_station)
  end

  private

  def validate!
    raise "Не верный формат начальной станции!" unless begin_station.is_a?(Station)
    raise "Не верный формат конечной станции!" unless end_station.is_a?(Station)
    true
  end
end
