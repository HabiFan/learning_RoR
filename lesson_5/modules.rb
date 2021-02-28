module MadeCompany
  attr_reader :company_name

  def made_company(name)
    self.company_name = name
  end

protected

attr_writer:company_name

end

module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    @@instances = 0

    def instances
      @@instances
    end

    def instances=(value)
      @@instances = value
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end

end
