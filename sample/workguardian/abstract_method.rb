module AbstractMethod
  def absdef(*method_names)
    for method_name in method_names
      define_abstract_method(method_name)
    end
  end

  def absdef_singleton(*method_names)
    for method_name in method_names
      define_abstract_singleton_method(method_name)
    end
  end

  def raise_error(method_name)
    raise "Undefined #{method_name} method."
  end

  def define_abstract_method(method_name)
    self.class_eval do
      define_method method_name do
        raise_error method_name
      end
    end
  end

  def define_abstract_singleton_method(method_name)
    self.class_eval do
      define_singleton_method method_name do
        raise_error method_name
      end
    end
  end
end
