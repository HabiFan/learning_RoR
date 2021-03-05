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
      case menu_items
      when 1
        puts "Введите название станиции: "
        create_station
      when 2 then menu_train
      when 3 then menu_route
      when 4 then menu_train_route if !trains.empty?
      when 5 then menu_info if !stations.empty?
      when 6 then break
      else
        INFO_LABEL
      end
    end
  end

  private

  attr_writer :stations, :trains, :routes

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
      4. Занимать место или объем в вагоне
      5. Список вагонов
      6. Вернуться к главному меню
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

  INFO_LABEL = "Выберите нужное действие"

  def menu_train
    loop do
      puts TRAIN_MENU
      menu_items = gets.chomp.to_i
      case menu_items
      when 1
        puts TRAIN_SUB_MENU
        selected_items = gets.chomp.to_i
        puts "Введите номер (XXXXX или ХХХ-ХХ) поезда: "
        create_train(selected_items)
      when 2
        puts "Выберите нужный поезд"
        add_carriage_train(object_select(trains, :@number)) if !trains.empty?
      when 3
        object_select(trains, :@number).drop_carriage if !trains.empty?
      when 4
        puts "Выберите нужный поезд"
        selected_train = object_select(trains, :@number) if !trains.empty?
        puts "Выберите нужный вагон"
        selected_carriage = carriage_select(selected_train.carriages) if !selected_train.carriages.empty?
        carriage_take_seat(selected_carriage)
      when 5
        index = 0
        object_select(trains, :@number).list_carriage do |carriage|
          puts "№ #{index += 1}, Тип: #{carriage.type}, Cвободно: #{carriage.free_seats}, Занято: #{carriage.take_seats}"
        end
      when 6 then break
      else
        INFO_LABEL
      end
    end
  end

  def menu_route
    loop do
      puts ROUTE_MENU
      menu_items = gets.chomp.to_i
      if menu_items == 1
        puts "Выберите начальную станцию: "
        start_station = object_select(stations, :@name)
        puts "Выберите конечную станцию: "
        end_station = object_select(stations, :@name)
        routes << Route.new(start_station, end_station)
      elsif menu_items == 2
        puts "Выберите маршрут и станцию: "
        route_select.add_station(object_select(stations, :@name))
      elsif menu_items == 3 && !routes.empty?
        puts "Выберите маршрут и нужную станцию: "
        delete_station_route(route_select)
      elsif menu_items == 4 && !trains.empty?
        puts "Выберите поезд и нужный маршрут: "
        object_select(trains, :@number).route_train(route_select)
      elsif menu_items == 5
        break
      else
        INFO_LABEL
      end
    end
  end

  def menu_train_route
    train = object_select(trains, :@number)
    unless train.route.nil?
      loop do
        puts TRAIN_ROUTE_SUB_MENU
        menu_items = gets.chomp.to_i
        case menu_items
        when 1
          train.next_route
          puts "Поезд на конечной станции" unless !train.next_station.nil?
        when 2
          train.last_route
          puts "Поезд в начале маршрута" unless !train.last_station.nil?
        when 3 then break
        else
          INFO_LABEL
        end
      end
    else
      puts "Для данного поезда нет маршрута"
    end
  end

  def menu_info
    loop do
      puts INFO_SUB_MENU
      menu_items = gets.chomp.to_i
      case menu_items
      when 1
        stations.each { |station| puts "#{station.name}" }
      when 2
        stations.each do |station|
          station.list_trains { |train| puts "На станции: #{station.name} находится поезд: #{train.number}, тип: #{train.type}, кол-во вагонов: #{train.carriages.count}" }
        end
      when 3 then break
      else
        INFO_LABEL
      end
    end
  end

  def create_station
    stations << Station.new(gets.chomp)
  end

  def create_train(type)
    trains << (type == 1 ? PassengerTrain.new(gets.chomp) : CargoTrain.new(gets.chomp))
    puts "Поезд успешно добавлен!"
    rescue RuntimeError => e
      puts e.message
      puts "Повторите попытку!"
      retry
    rescue StandardError => e
      puts e.message
      puts "Повторите попытку!"
  end

  def add_carriage_train(train)
    puts "Введите количество мест(объем) вагона: "
    if train.train_passenger?
      train.add_carriage(PassengerCarriage.new(gets.chomp.to_i))
    else
      train.add_carriage(CargoCarriage.new(gets.chomp.to_f))
    end
    puts "Вагон добавлен к поезду!"
    rescue RuntimeError => e
      puts e.message
      puts "Повторите попытку!"
      retry
    rescue StandardError => e
      puts e.message
      puts "Повторите попытку!"
  end

  def object_select(obj, var1)
    obj.each_with_index { |value, index| puts "#{index + 1}. #{value.instance_variable_get(var1)}" }
    obj[gets.chomp.to_i - 1]
  end

  def carriage_select(carriages)
    carriages.each_with_index { |value, index| puts "Вагон №#{index + 1}." }
    carriages[gets.chomp.to_i - 1]
  end

  def carriage_take_seat(carriage)
    if carriage.is_a?(PassengerCarriage)
      carriage.take_seat
    else
      puts "Введите объем: "
      carriage.take_seat(gets.chomp.to_f)
    end
    puts "Резервирование мета(объема) прошла успешно!"
    rescue RuntimeError => e
      puts e.message
      puts "Повторите попытку!"
      retry
    rescue StandardError => e
      puts e.message
      puts "Повторите попытку!"
  end

  def route_select
    routes.each_with_index { |route, index| puts "#{index + 1}. #{route.begin_station.name}..#{route.end_station.name}" }
    routes[gets.chomp.to_i - 1]
  end

  def delete_station_route(selected)
    selected.stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    selected.delete_station(selected.stations[gets.chomp.to_i - 1])
  end
end

MainApp.new
