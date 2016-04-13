# 擬似的な抽象メソッドを定義するためのモジュール
# サブクラスに定義されていなければ例外を投る
module AbstractMethod
  # 擬似抽象インスタンスメソッドを定義する内部DSL
  def absdef(*method_names)
    for method_name in method_names
      define_abstract_method(method_name)
    end
  end

  # 擬似抽象クラスメソッドを定義する内部DSL
  def absdef_singleton(*method_names)
    for method_name in method_names
      define_abstract_singleton_method(method_name)
    end
  end

  # 例外を投る
  def raise_error(method_name)
    raise "Undefined #{method_name} method."
  end

  # 擬似抽象インスタンスメソッドを定義する
  def define_abstract_method(method_name)
    self.class_eval do
      define_method method_name do
        raise_error method_name
      end
    end
  end

  # 擬似抽象クラスメソッドを定義する
  def define_abstract_singleton_method(method_name)
    self.class_eval do
      define_singleton_method method_name do
        raise_error method_name
      end
    end
  end
end
