# frozen_string_literal: true

require_relative 'modules'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  NAME_FORMAT = /^([a-z]|[а-я])+\d*$/i.freeze

  validate :name, :type, String
  validate :name, :format, NAME_FORMAT
  validate :name, :presence

  class << self; attr_accessor :all; end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    self.class.all ||= []
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

  def to_s
    name.to_s
  end

  private

  def validate!
    raise 'Имя станции должен содержать не менее 3-х символов' if name.to_s.length < 3

    super

    true
  end
end
