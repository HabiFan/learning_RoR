require_relative "modules"

class Carriage
  include MadeCompany
  attr_reader :type

  def initialize(type)
    @type = type
  end
end
