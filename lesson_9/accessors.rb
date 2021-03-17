# frozen_string_literal: true

module Accessors
  # rubocop:disable Metrics/MethodLength

  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      var_attr = "@#{attr}".to_sym
      var_hist = "@#{attr}_his"

      define_method(attr) { instance_variable_get(var_attr) }

      define_method("#{attr}=") do |value|
        instance_variable_set(var_hist, []) if instance_variable_get(var_hist).nil?
        instance_variable_get(var_hist).push(value)
        instance_variable_set(var_attr, value)
      end

      define_method("#{attr}_history") { instance_variable_get(var_hist) }
    end
  end

  # rubocop:enable Metrics/MethodLength

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym

    define_method(name) { instance_variable_get(var_name) }

    define_method("#{name}=") do |value|
      raise 'Не верный тип.' unless value.is_a? type

      instance_variable_set(var_name, value)
    end
  end
end
