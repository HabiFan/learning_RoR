# frozen_string_literal: true

require_relative 'validation'
require_relative 'modules'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :begin_station, :end_station

  validate :begin_station, :type, Station
  validate :end_station, :type, Station

  def initialize(begin_station, end_station)
    @begin_station = begin_station
    @end_station = end_station
    validate!
    @stations = [@begin_station, @end_station]
    register_instance
  end

  def add_station(station)
    raise 'Не верный формат добавляемой станции!' unless station.is_a?(Station)

    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if station != (@begin_station && @end_station)
  end

  def to_s
    "#{@begin_station}..#{@end_station}"
  end
end
