require_relative "station"
require_relative "route"
require_relative "train"
require_relative "carriage"
require_relative "passenger_train"
require_relative "cargo_train"
require_relative "passenger_carriage"
require_relative "cargo_carriage"

class MainApp
  attr_reader :stations, :trains, :routes

  START_MENU = <<~here
      Выберите нужное действие
      1. Создать станцию
      2. Создать поезд, добавить или отцепить вагоны
      3. Создать маршрут, назначить маршрут поезду
      4. Перемещение поезда по маршруту
      5. Получить информацию (о станициях и поездах)
      6. Выход из программы
  here

  TRAIN_MENU = <<~here
      Выберите нужное действие
      1. Создать поезд
      2. Добавить вагон к поезду
      3. Отцепить вагон от поезда
      4. Вернуться к главному меню
  here

  ROUTE_MENU = <<~here
      Выберите нужное действие
      1. Создать маршрут
      2. Добавить промежуточние станции
      3. Удалить промежуточние станици
      4. Назначить маршрут к поезду
      5. Вернуться к главному меню
  here

  INFO_SUB_MENU = <<~here
      Выберите действия
      1. Список всех станции
      2. Список поездов на станции
      3. Выход в главное меню
  here

  TRAIN_ROUTE_SUB_MENU = <<~here
      Выберите действия для поезда
      1. Движение вперед
      2. Движение назад
      3. Выход в главное меню
  here

  TRAIN_SUB_MENU = <<~here
      Выберите тип поезда (1 или 2):
      1. Пассажирский
      2. Грузовой
  here

  def initialize
    @stations = []
    @trains = []
    @routes =[]
    start_menu
  end

  def start_menu
    loop do
      puts START_MENU
      menu_items = gets.chomp.to_i
      create_station if menu_items == 1
      menu_train if menu_items == 2
      menu_route if menu_items == 3
      menu_train_route if menu_items == 4 && !trains.empty?
      menu_info if menu_items == 5 && !stations.empty?
      break if menu_items == 6
    end
  end

  def menu_train
    loop do
      puts TRAIN_MENU
      menu_items = gets.chomp.to_i
      if menu_items == 1
        puts TRAIN_SUB_MENU
        create_train(gets.chomp.to_i)
      end
      add_carriage_train(object_select(trans)) if menu_items == 2 && !trains.empty?
      object_select(trans).drop_carriage if menu_items == 3 && !trains.empty?
      break if menu_items == 4
    end
  end

  def menu_route
    loop do
      puts ROUTE_MENU
      menu_items = gets.chomp.to_i
      create_route if menu_items == 1
      insert_route if menu_items == 2
      delete_station_route if menu_items == 3 && !routes.empty?
      add_train_route if menu_items == 4 && !trains.empty?
      break if menu_items == 5
    end
  end

  def menu_train_route
    train = object_select(trains, :@number)
    if train.route.nil?
      puts "Для данного поезда нет маршрута"
    else
      loop do
        puts TRAIN_ROUTE_SUB_MENU
        menu_items = gets.chomp.to_i
        if menu_items == 1
          train.next_route
          puts "Поезд на конечной станции" unless !train.next_station.nil?
        end
        if menu_items == 2
          train.last_route
          puts "Поезд в начале маршрута" unless !train.last_station.nil?
        end
        break if menu_items == 3
      end
    end
  end

  def menu_info
    loop do
      puts INFO_SUB_MENU
      menu_items = gets.chomp.to_i
      stations.each { |station| puts "#{station.name}" } if menu_items == 1
      trains.each { |train|  puts "На станции: #{train.current_station.name} находится поезд: #{train.number} "} if menu_items == 2
      break if menu_items == 3
    end
  end

  private

  attr_writer :stations, :trains, :routes

  def create_station
    puts "Введите название станиции: "
    stations << Station.new(gets.chomp)
  end

  def create_train(type)
    puts "Введите номер поезда: "
    trains << (type == 1 ? PassengerTrain.new(gets.chomp) : CargoTrain.new(gets.chomp))
  end

  def add_carriage_train(train)
    if train.train_passenger?
      train.add_carriage(PassengerCarriage.new)
    else
      train.add_carriage(CargoCarriage.new)
    end
  end

  def object_select(obj, var1)
    obj.each_with_index { |value, index| puts "#{index + 1}. #{value.instance_variable_get(var1)}" }
    obj[gets.chomp.to_i - 1]
  end

  def route_select
    puts "Выберите маршрут: "
    routes.each_with_index { |route, index| puts "#{index + 1}. #{route.begin_station.name}..#{route.end_station.name}" }
    routes[gets.chomp.to_i - 1]
  end

  def create_route
    puts "Выберите начальную станцию: "
    start_station = object_select(stations, :@name)
    puts "Выберите конечную станцию: "
    end_station = object_select(stations, :@name)
    routes << Route.new(start_station, end_station)
  end

  def insert_route
    puts "Выберите станцию: "
    route_select.add_station(object_select(stations, :@name))
  end

  def add_train_route
    puts "Выберите поезд: "
    object_select(trains, :@number).route_train(route_select)
  end

  def delete_station_route
    selected = route_select
    puts "Выберите станцию: "
    selected.stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    selected.delete_station(selected.stations[gets.chomp.to_i - 1])
  end
end
