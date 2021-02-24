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
      3. Перемещение поезда по маршруту
      4. Получить информацию (о станиция и поездах)
      5. Выход из программы
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
      2. Добавить промежуточние стации
      3. Назначить маршрут к поезду
      4. Вернуться к главному меню
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
    break if menu_items == 5
  end
end

def menu_train
  loop do
    puts TRAIN_MENU
    menu_items = gets.chomp.to_i
    if menu_items == 1
      puts "Выберите тип поезда (1 или 2): "
      puts "1. Пассажирский"
      puts "2. Грузовой"
      create_train(gets.chomp.to_i)
    end
    add_carriage_train(train_select) if menu_items == 2 && !trains.empty?
    train_select.drop_carriage if menu_items == 3 && !trains.empty?
    break if menu_items == 4
  end
end

def menu_route
  loop do
    puts ROUTE_MENU
    menu_items = gets.chomp.to_i
    create_route if menu_items == 1
    insert_route if menu_items == 2
    add_train_route if menu_items == 3
    break if menu_items == 4
  end
end

# def menu_stations
#   loop do
#     puts STATION_MENU
#     menu_station = gets.chomp.to_i
#     if menu_station == 1
#       create_station
#     elsif menu_station == 2
#       break
#       start_menu
#     else
#       puts "Выбирете действия!"
#     end
#   end
# end



private

attr_writer :stations, :trains, :routes

def create_station
  puts "Введите название станиции: "
  stations << Station.new(gets.chomp)
end

def create_train(type)
  puts "Введите номер поезда: "
  number_train = gets.chomp
  trains << (type == 1 ? PassengerTrain.new(number_train) : CargoTrain.new(number_train))
end

def add_carriage_train(train)
  if train.train_passenger?
    train.add_carriage(PassengerCarriage.new)
  else
    train.add_carriage(CargoCarriage.new)
  end
end

def train_select
  puts "Выберите поезд: "
  trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" }
  trains[gets.chomp.to_i - 1]
end

def station_select
  stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
  stations[gets.chomp.to_i - 1]
end

def route_select
  puts "Выберите маршрут: "
  routes.each_with_index { |route, index| puts "#{index + 1}. #{route.begin_station}..#{route.end_station}" }
  routes[gets.chomp.to_i - 1]
end

def create_route
  puts "Выберите начальную станцию: "
  start_station = station_select
  puts "Выберите конечную станцию: "
  end_station = station_select
  routes << Route.new(start_station, end_station)
end

def insert_route
  route_item = route_select
  puts "Выберите станцию: "
  station_select
  route_item.add_station(station_select)
end

def add_train_route
  train_item = train_select
  train_item.route_train(route_select)
end

end
