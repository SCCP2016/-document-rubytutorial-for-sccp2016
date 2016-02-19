### 7.1 モジュールの定義と使い方

前節に説明した継承を使うことでクラスに機能を追加することは可能だが、以下のような多重に継承することは禁止されている。

```ruby
class Foo
  def initialize
    @x = 'abc' # フィールドxはString
  end
  def method_a
    puts @x
  end
end

class Bar
  def initialize
    @x = 123 # フィールドxはFixnum
  end
  def method_a
    puts @x
  end
end

class Fizz < Foo < Bar
  def initialize
    super('abc') # どちらのコンストラクタを呼べばいいかわからない。
  end
  def method_b
    method_a # どちらのmethod_aが呼び出して良いかわからない。 @x はどちらのクラスのフィールド？
  end
end
```

多重継承ではフィールドやメソッドが同名の場合、どの親クラスのものか
特定できない(特定する方法があったとしても複雑な仕組みになってしまう。)。
クラスの継承関係が複雑になってしまう(親が一意に特定できない)ため多重継承を意図的にサポートしない言語がほとんどである。この問題は*菱形継承問題*などと名前が付けられているので興味があれば調べてみるとよいだろう。(https://ja.wikipedia.org/wiki/菱形継承問題)

そこでRubyではモジュールという追加したい機能を自由に選択し、クラスに付与するための機構が用意されている。以下がモジュールの例である。

```ruby
module Foo
  def method_a
    @x * 2
  end
  def method_c
    "This is a Foo's instance method"
  end
end

module Bar
  def method_b
    @x + 10
  end
  def method_c
    "This is a Bar's instance method"
  end
end

class Fizz
  include Foo, Bar

  def initialize
    @x = 123
  end
end

fizz = Fizz.new
fizz.method_a()
=> 246
fizz.method_b()
=> 133
fizz.method_c()
=> "This is a Foo's instance method"
Fizz.ancestors
=> [Fizz, Foo, Bar, Object, Kernel, BasicObject]
```

上の例では、モジュール*Foo*, *Bar*が定義されクラス*Fizz*に*include*キーワードによって取り込まれている。
クラスがモジュールを取り込むことを*Mix-in*(ミックスイン)と呼ぶ。
モジュールの定義の仕方はクラスと同様である。*method_a*,*method_b*は、それぞれモジュール*Foo*, *Bar*で定義されて、ミックスインされたあと無事*Fizz*クラスのインスタンスで呼び出すことができている。それでは多重継承で問題となっていた同名のフィールドやメソッドはどのように解決されているのだろうか。まず、同名のメソッドである*method_c*を呼び出すと、*Foo*モジュールで定義された*method_c*が呼び出されていることがわかる。なぜこのような呼び出しになるかを確かめるには、クラスの継承関係を確認する必要がある。全てのクラスには*ancestors*というクラスメソッドが用意されているので呼び出すと、継承されたクラスとミックスインされたモジュールの一覧が配列の形になって返ってくるのがわかる。
Rubyのミックスインでは、親が複数あると言うアプローチではなく線形的に親子関係を表すことで同名メソッドを解決している。つまり配列の先頭から見ていき、自身のクラス(*Fizz*)の次のモジュール*Foo*が*method_c*を持っていたため、*Foo*モジュールの*method_c*が採用されたというわけである。一方*Bar*モジュールの*method_c*を採用するには*include*キーワードのミックスイン順序を逆にすれば良い。

次に、以下のようにモジュールをインスタンス化を試みて欲しい。

```
Foo.new
<main>': undefined method `new' for Foo:Module (NoMethodError)
```

すると以上のようなエラーがでる。モジュールはインスタンス化ができないという規則にすることで
クラスの多重継承とは異なるものだと理解できるだろう。フィールド*x*はモジュール自身のインスタンス変数ではなく、モジュールをミックスインしたクラスのインスタンス変数として一意に定まるので同名フィールド問題も解決している。

モジュールについてまとめると以下のようになる。

- モジュールはインスタンス化できない
- モジュールはクラス(もしくは別モジュール)に対して複数ミックスインすることができる
- 菱型継承問題を線形的にすることで、同一フィールド、メソッド、複雑な継承関係を解決している
- モジュールはミックスインする順序が大切である
