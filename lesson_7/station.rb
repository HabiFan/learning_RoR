require_relative "modules"

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  NAME_FORMAT = /^([a-z]|[а-я])+\d*$/i
  @@all = []

  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    self.class.all << self
    register_instance
  end

  def take_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    return if @trains.empty?
    @trains.select { |train| train.type == type }
  end

  def list_trains(&block)
    @trains.each(&block) if block_given?
  end

  private

  def validate!
    raise "Имя станции может быть только текстовым" unless name.instance_of? String
    raise "Имя станции должен начинатся с строчных или прописных букв" if name !~ NAME_FORMAT
    raise "Имя станции должен содержать не менее 3-х символов" if name.to_s.length < 3
    true
  end

end
