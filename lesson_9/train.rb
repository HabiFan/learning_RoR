# frozen_string_literal: true

require_relative 'modules'

class Train
  include MadeCompany
  include InstanceCounter
  include Validation

  attr_accessor :speed
  attr_reader :number, :type, :carriages, :current_station, :route

  NUMBER_FORMAT = /^(\w|[а-я0-9]){3}+-*+(\w|[а-я0-9]){2}$/i.freeze
  TYPE_FORMAT = /^([a-z]|[а-я]){3,}$/i.freeze

  class << self; attr_accessor :trains; end

  def self.find(number_train)
    trains.select { |key| key == number_train }
  end

  def initialize(number, type)
    @number = number
    @type = type
    validate!
    @carriages = []
    self.speed = 0
    self.class.trains ||= {}
    self.class.trains[number] = type
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    return puts 'Поезд движется, невозможно прицепить вагон!' if speed != 0

    @carriages << carriage if type == carriage.type
  end

  def drop_carriage
    return puts 'Поезд движется, невозможно отцепить вагон!' if speed != 0

    @carriages.pop
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
    puts 'Это конечная станция' if @current_station == @route.end_station
  end

  def last_station
    @route.stations[current_index - 1] if @current_station != @route.begin_station
    puts 'Это начальная станция' if @current_station == @route.begin_station
  end

  def train_passenger?
    type == :passenger
  end

  def list_carriage(&block)
    @carriages.each(&block) if block_given?
  end

  def to_s
    "Поезд №: #{number} тип: #{type} кол-во вагонов: #{carriages.count}"
  end

  private

  attr_writer :current_station, :route

  def current_index
    route.stations.index(current_station)
  end

  def validate!
    raise 'Тип поезда должен быть Symbol' unless type.instance_of? Symbol

    if type !~ TYPE_FORMAT
      raise 'Неверные тип поезда! Тип должен содержать не менее 3-х символов,
             включая только строчные или прописные буквы!'
    end
    raise 'Номер поезда должен быть текстовым' unless number.instance_of? String
    raise 'Неверный формат номера поезда' if number !~ NUMBER_FORMAT

    true
  end
end
