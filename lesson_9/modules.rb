# frozen_string_literal: true

module MadeCompany
  attr_accessor :company_name
end

module Validation
  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    def register_instance
      self.class.instances += 1
    end
  end
end

module CarriageSeat
  attr_reader :count_seat, :take_seats

  def take_seat(size = 1)
    @take_seats += size if @count_seat > @take_seats
    validate!
  end

  def free_seats
    @count_seat - @take_seats
  end

  def to_s
    "Тип: #{type}, Cвободно: #{free_seats} Занято: #{take_seats}"
  end

  protected

  attr_writer :take_seats

  def validate!
    unless (count_seat.instance_of? Integer) || (count_seat.instance_of? Float)
      raise 'Количество мест(объема) должен быть числовым'
    end
    raise 'Свободных мест(объемов) нет' if count_seat <= take_seats

    true
  end
end

module AppMenuCaptions
  attr_reader :labels

  # rubocop:disable Metrics/MethodLength

  def initialize
    @labels = {
      station: 'Введите название станиции: ',
      train_number: 'Введите номер (XXXXX или ХХХ-ХХ) поезда: ',
      choose_train: 'Выберите нужный поезд',
      choose_carriage: 'Выберите нужный вагон',
      start_station: 'Выберите начальную станцию: ',
      end_station: 'Выберите конечную станцию: ',
      choose_route: 'Выберите маршрут: ',
      choose_obj: 'Выберите нужное: ',
      choose_station: 'Выберите станцию: ',
      choose_train_route: 'Выберите поезд и нужный маршрут: ',
      train_end_station: 'Поезд на конечной станции',
      train_start_station: 'Поезд в начале маршрута'
    }
  end

  # rubocop:enable Metrics/MethodLength

  protected

  attr_writer :labels

  START_MENU = <<~HERE
    Выберите нужное действие
    1. Создать станцию, поезд, маршрут
    2. Управление поездом
    3. Управление маршрутом
    4. Получить информацию (о станициях и поездах)
    5. Выход из программы
  HERE

  CREATE_MENU = <<~HERE
    Выберите нужное действие
    1. Cтанцию
    2. Поезд
    3. Маршрут
    4. Вернуться к главному меню
  HERE

  TRAIN_MENU = <<~HERE
    Выберите нужное действие
    1. Управление вагонами
    2. Назначить маршрут к поезду
    3. Движение поезда
    4. Вернуться к главному меню
  HERE

  CARRIAGE_MENU = <<~HERE
    Выберите нужное действие
    1. Добавить вагон к поезду
    2. Отцепить вагон от поезда
    3. Занимать место или объем в вагоне
    4. Список вагонов
    5. Вернуться к главному меню
  HERE

  ROUTE_MENU = <<~HERE
    Выберите нужное действие
    1. Добавить промежуточние станции
    2. Удалить промежуточние станици
    3. Вернуться к главному меню
  HERE

  INFO_SUB_MENU = <<~HERE
    Выберите действия
    1. Список всех станции
    2. Список поездов на станции
    3. Выход в главное меню
  HERE

  TRAIN_ROUTE_SUB_MENU = <<~HERE
    Выберите действия для поезда
    1. Движение вперед
    2. Движение назад
    3. Выход в главное меню
  HERE

  TRAIN_SUB_MENU = <<~HERE
    Выберите тип поезда (1 или 2):
    1. Пассажирский
    2. Грузовой
  HERE

  INFO_LABEL = 'Выберите нужное действие'
end
