module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validation_list
      @validation_list ||= []
    end

    def validate(attr, type, option = nil)
      validation_list << [attr, type, option]
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

  end
end
