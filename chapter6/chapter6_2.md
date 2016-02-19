### 6.2 クラス変数とクラスメソッド

前節でオブジェクトは固有の状態「フィールド」を持っていることを説明した。
クラス全体で共有の状態を扱いたい場合は。*クラス変数*を使用する。
以下がクラス変数の例である。

```ruby
class Human
  @@population = 0

  def initialize(name, age)
    @name = name
    @age = age
    @@population += 1
  end

  def to_s
    "#{@name}(#{@age})"
  end

  def total_population
    @@population
  end
end

john = Human.new('John', 15)
mike = Human.new('Mike', 18)
john.total_population
=> 2
mike.total_population
=> 2
```

クラス変数は@@(アットマークアットマーク)を変数名の先頭に付けることで宣言できる。
クラスはメソッドの集合ではなく、式の集合であることを覚えているだろうか。
そのためメソッドの外でクラス変数の初期化を行うことができる。
この初期化が行われるのは、クラスの定義がされたときの一度きりである。
あとはフィールド同様どのメソッド(同一クラス内の式)で呼び出し可能である。
オブジェクト共有の状態であるフィールド(インスタンスフィールド)と異なる点は、クラス共有の状態として使えるため、上の例では*john*も*mike*も同じ値を返す。つまりこの世界では世界人口(@@count)を人間は常識として知っている。人間の常識として世界人口があるため、世界人口を知るためには人間を介する必要はなくなる。その場合にはクラスメソッドを利用する。

```ruby
# 上のコードから一部抜粋・修正

def self.total_population # または def Human.total_population でも可
  @@population
end

...

Human.total_population
=> 2
```

以上のように、*self.* をメソッド名の先頭に付けることで、インスタンスメソッドをクラスメソッドに
変換することができる。これで晴れて世界人口は世界の常識となった。逆にインスタンスからクラスメソッドを呼び出すことができなくなったので注意しよう。

演習:

クラス変数とクラスメソッドを利用して、familyName単位での人の数を出力出来るようにせよ。

```ruby
Human.new('Willard', 'Smith', 47)
Human.new('Shelley', 'Smith', 43)
Human.new('Frank', 'Williams', 63)
Human.new('Scott', 'Brown', 32)
Human.new('Jane', 'Brown', 25)
Human.new('Bobby', 'Brown', 22)

Human.family_population('Smith')
=> 2
Human.family_population('Williams')
=> 1
Human.family_population('Brown')
=> 3
```
