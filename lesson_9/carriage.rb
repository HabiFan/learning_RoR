# frozen_string_literal: true

class Carriage
  include MadeCompany
  include Validation

  attr_reader :type_carriage

  TYPE_FORMAT = /^([a-z]|[а-я]){3,}$/i.freeze

  validate :type_carriage, :presence
  validate :type_carriage, :type, Symbol
  validate :type_carriage, :format, TYPE_FORMAT

  def initialize(type_carriage)
    @type_carriage = type_carriage
    validate!
  end
end
