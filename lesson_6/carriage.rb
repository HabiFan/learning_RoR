require_relative "modules"

class Carriage
  include MadeCompany
  include Validation
  attr_reader :type

  TYPE_FORMAT = /^([a-z]|[а-я]){3,}$/i

  def initialize(type)
    @type = type
    validate!
  end

  private

  def validate!
    raise "Тип вагона должен быть Symbol" unless type.instance_of? Symbol
    raise "Неверные формат вагона! Тип должен содержать не менее 3-х символов, включая только строчные или прописные буквы!" if type !~ TYPE_FORMAT
    true
  end
end
