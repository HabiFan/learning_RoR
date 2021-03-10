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
