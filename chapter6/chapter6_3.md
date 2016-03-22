### 6.3 アクセサ

オブジェクト指向型プログラミングで大切な考え方の一つに**カプセル化**がある。これはオブジェクトの状態を外部から隠し、不正な状態の変更によるバグを抑制するというものである。このため、Rubyではクラス内でインスタンス変数を定義しただけではオブジェクトの外からはその変数にアクセスする手段はない。

```ruby
class Human
  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_s
    "#{@name}(#{@age})"
  end
end
```

例えばカプセル化がされていない場合、次のようなコードが意図せず実行可能になってしまう。

```ruby
jhon = Human.new('Jhon', 18)
jhon.name = 'Pole'

p jhon.to_s
#=> "Pole(18)"
```

このように、"18歳のJhon"というデータの価値がなくなっておかしなオブジェクトができてしまう。デフォルトでインスタンス変数にアクセスできないことにすれば、意図的に参照できるようにしない限りこのようなことが起きることはない。

この例で*@name*、*@age*に直接アクセスできるようにするためにはそれ用のメソッドを定義する必要がある。

```ruby
class Human
  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_s
    "#{@name}(#{@age})"
  end

  # ここから追加
  def set_name(name)
    @name = name
  end

  def get_name
    @name
  end

  def set_age(age)
    @age = age
  end

  def get_age
    @age
  end
  # ここまで追加
end
```

見て分かるように、各変数ごとに代入・参照メソッドを用意すると冗長なコードが並んだようなクラスになってしまう。この冗長なコードはアクセサメソッドを使って自動生成することで解決できる。

```ruby
class Human
  attr_accessor :name, :age # 追加

  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_s
    "#{@name}(#{@age})"
  end
end

jhon = Human.new('Jhon', 18)

p jhon.name
#=> "Jhon"

p jhon.name = "Pole"
#=> "Pole"

p jhon.age
#=> 18

p jhon.age = 19
#=> 19
```

*attr_accessor*は、渡したシンボル名のインスタンス変数の代入・参照メソッドを生成するメソッドである。アクセサメソッドには３種類あり、
- *attr_accessor*: 代入・参照メソッド
- *attr_read*: 参照メソッドのみ
- *attr_write*: 代入メソッドのみ

それぞれ、どこまでインスタンス変数へのアクセスを許すかによって使い分ける。