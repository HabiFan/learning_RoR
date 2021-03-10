# frozen_string_literal: true

require_relative 'modules'

class Carriage
  include MadeCompany
  include Validation

  attr_reader :type

  TYPE_FORMAT = /^([a-z]|[а-я]){3,}$/i.freeze

  def initialize(type)
    @type = type
    validate!
  end

  private

  def validate!
    raise 'Тип вагона должен быть Symbol' unless type.instance_of? Symbol

    if type !~ TYPE_FORMAT
      raise 'Неверные формат вагона!
             Тип должен содержать не менее 3-х символов,
             включая только строчные или прописные буквы!'
    end

    true
  end
end
