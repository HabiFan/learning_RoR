require_relative "modules"

class Station
  include InstanceCounter
  
  attr_reader :name, :trains

  @@all = []

  def self.all
    @@all
  end

  def initialize(name)
    @name = name
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

end
