# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'carriage'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'modules'
require_relative 'validation'
require_relative 'accessors'

class MainApp
  include AppMenuCaptions

  attr_reader :stations, :trains, :routes

  def initialize
    super
    @stations = []
    @trains = []
    @routes = []
    start_menu
  end

  def start_menu
    loop do
      puts START_MENU
      case gets.chomp.to_i
      when 1 then menu_create
      when 2 then menu_train unless trains.empty?
      when 3 then menu_route
      when 4 then menu_info
      when 5 then break
      else INFO_LABEL; end
    end
  end

  private

  attr_writer :stations, :trains, :routes

  def menu_create
    loop do
      puts CREATE_MENU
      case gets.chomp.to_i
      when 1 then create_station
      when 2 then menu_sub_train
      when 3 then create_route
      when 4 then break
      else INFO_LABEL; end
    end
  end

  def create_route
    puts labels[:start_station]
    start_station = object_select(stations)
    puts labels[:end_station]
    end_station = object_select(stations)
    routes << Route.new(start_station, end_station)
  end

  def menu_train
    selected_train ||= object_select(trains)
    loop do
      puts TRAIN_MENU
      case gets.chomp.to_i
      when 1 then menu_carriage(selected_train)
      when 2 then selected_train.route_train(object_select(routes))
      when 3 then menu_train_route(selected_train) unless selected_train.route.nil?
      when 4 then break
      else INFO_LABEL; end
    end
  end

  def menu_sub_train
    puts TRAIN_SUB_MENU
    create_train(gets.chomp.to_i)
  end

  def menu_carriage(train)
    loop do
      puts CARRIAGE_MENU
      case gets.chomp.to_i
      when 1 then add_carriage_train(train)
      when 2 then train.drop_carriage
      when 3 then take_seat_carriage(train)
      when 4 then info_trains_carriage(train)
      when 5 then break
      else INFO_LABEL; end
    end
  end

  def menu_route
    return if routes.empty?

    selected_route ||= object_select(routes)
    loop do
      puts ROUTE_MENU
      case gets.chomp.to_i
      when 1 then selected_route.add_station(object_select(stations))
      when 2 then delete_station_route(selected_route)
      when 3 then break
      else INFO_LABEL; end
    end
  end

  def menu_train_route(train)
    puts TRAIN_ROUTE_SUB_MENU
    loop do
      puts INFO_LABEL
      case gets.chomp.to_i
      when 1 then train.next_route if train.next_station.nil?
      when 2 then train.last_route if train.last_station.nil?
      when 3 then break
      end
    end
  end

  def menu_info
    loop do
      break if stations.empty?

      puts INFO_SUB_MENU
      case gets.chomp.to_i
      when 1 then stations.each { |station| puts station.name.to_s }
      when 2 then info_list_station
      when 3 then break
      else INFO_LABEL; end
    end
  end

  def create_station
    puts labels[:station]
    stations << Station.new(gets.chomp)
  end

  def create_train(type)
    puts labels[:train_number]
    trains << (type == 1 ? PassengerTrain.new(gets.chomp) : CargoTrain.new(gets.chomp))
    puts 'Поезд успешно добавлен!'
  rescue RuntimeError => e
    puts "#{e.message}\n Повторите попытку!"
    retry
  end

  def take_seat_carriage(train)
    puts labels[:choose_carriage]
    selected_carriage = object_select(train.carriages)
    carriage_take_seat(selected_carriage)
  end

  def info_trains_carriage(train)
    index = 0
    train.list_carriage do |carriage|
      puts "№ #{index += 1}, #{carriage}"
    end
  end

  def add_carriage_train(train)
    puts 'Введите количество мест(объем) вагона: '
    if train.train_passenger?
      train.add_carriage(PassengerCarriage.new(gets.chomp.to_i))
    else
      train.add_carriage(CargoCarriage.new(gets.chomp.to_f))
    end
    puts 'Вагон добавлен к поезду!'
  rescue RuntimeError => e
    puts "#{e.message}\n Повторите попытку!"
    retry
  end

  def object_select(obj)
    puts labels[:choose_obj]
    obj.each_with_index { |value, index| puts "#{index + 1}. #{value}" }
    obj[gets.chomp.to_i - 1]
  end

  def carriage_take_seat(carriage)
    if carriage.is_a?(PassengerCarriage)
      carriage.take_seat
    else
      puts 'Введите объем: '
      carriage.take_seat(gets.chomp.to_f)
    end
    puts 'Резервирование места(объема) прошла успешно!'
  rescue RuntimeError => e
    puts "#{e.message}\n Повторите попытку!"
    retry
  end

  def delete_station_route(selected)
    selected.stations.each_with_index { |station, index| puts "#{index + 1}. #{station}" }
    selected.delete_station(selected.stations[gets.chomp.to_i - 1])
  end

  def info_list_station
    stations.each do |station|
      station.list_trains { |train| puts "На станции: #{station} #{train}" }
    end
  end
end
# rubocop:enable Metrics/ClassLength

MainApp.new
