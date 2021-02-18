class Station
  attr_reader :name, :trains
  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def current_take_trains
    return "Нет поездов!" if @trains.empty?
    @trains.each { |train| puts "Поезд номером: #{train.number}" }
  end

  def current_take_trains_type
    return "Нет поездов!" if @trains.empty?
    count_freight = 0
    @trains.each { |train| count_freight += 1 if train.type == 1 }
    puts "Количество поездов: #{@trains.size} из них грузовых: #{count_freight}, пассажирских: #{@trains.size - count_freight}"
  end
end
