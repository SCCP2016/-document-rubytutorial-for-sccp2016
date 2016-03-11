### 色々なモジュール

Rubyには標準で定義されている便利なモジュールがたくさんある。このページではその中から3つをピックアップして紹介していく。

#### Singleton

一般的にシングルトンとは、プログラム内で意図的にインスタンスを一つだけ生成するように設計されたクラスやそのオブジェクトのことで、それぞれシングルトンクラスやシングルトンオブジェクトと呼ばれる。プログラム全体に共通の状態や処理を持たせたい時、プログラム全体で整合性のある情報を扱いたい時に使われる。

例えば、ハッシュと一緒に解説したシンボルはシングルトンオブジェクトである。

#### Enumerable

Enumerableはたくさんの、データの集合を扱うためのメソッドが定義されたモジュールである。それらのメソッドの全てがeachメソッドを使って定義されているのでincludeするクラスにはeachメソッドが定義されていなければならない。逆に言えばeachメソッドが定義されていればEnumerableモジュールをincludeして使うことができる。

では、Enumerableモジュールを使って自作のスタック、MyStackクラスを作成してみよう。

```ruby
# MyStack.rb

class MyStack
  include Enumerable

  def initialize()
    @array = []
  end

  def each(&block)
    @array.each(&block)
  end

  def push(value)
    tmp = @array
    tmp << value
  end

  def push!(value)
    @array << value
  end

  def pop()
    @array[-1]
  end

  def pop!()
    @array.delete_at(-1)
  end
end

stack = MyStack.new
stack.push!(1)
stack.push!(2)
stack.push!(3)
stack.push!(4)
stack.push!(5)
stack.each {|i|
  p i
}

puts "\npow"
stack.map{|i| i * i}.each {|i|
  p i
}

puts "\neven"
stack.select{|i| i % 2 == 0}.each {|i|
  p i
}
```
```
$ ruby MyStack.rb
1
2
3
4
5

pow
1
4
9
16
25

even
2
4
```

#### Comparable

Comparableは比較演算子*<=,<,==,>,>=*で比較できるようにするためのモジュールである。これらのメソッドは、メソッド*<=>*を使って実装されているので、Enumerableでのeachメソッドのようにincludeするクラスで*<=>*が実装されていれば使用することができる。

*a.<=>(b)*メソッドで期待されている戻り値は以下の通りである。

- a > b なら正の整数
- a = b なら0
- a < b なら負の整数
- aとbが比較できなければnil
