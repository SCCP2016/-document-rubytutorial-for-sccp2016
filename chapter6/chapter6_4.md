### 6.4 継承

前節ではRubyでオブジェクト指向をする上で重要なクラスの概念について学んだ。
早速これを利用して、プログラマのクラスを定義すると以下のようになるだろう。

```ruby
class Programmer
  def initialize(name, age, languages)
    @name = name
    @age = age
    @languages = languages
  end

  def to_s
    "#{@name} (#{@age})\n" + @languages.join(',')
  end
end

Programmer.new('Mike', '18', ['C++', 'Ruby', 'PHP', 'Java'])
=> "Mike (18)\nC++,Ruby,PHP,Java"

```

プログラマは習得言語を文字列の配列で持ち、*to_s*メソッドで表示する。
しかし、プログラマは人間でもあるため、大半が人間の機能と重複している。
このときプログラマの差分のみを実装するには継承という仕組みを使う。

```ruby
class Programmer < Human
  def initialize(name, age, languages)
    super(name, age)
    @languages = languages
  end

  def to_s
    super.to_s + "\n" + @languages.join(',')
  end
end
```

上の例では*Programmer*クラスが*Human*クラスを継承している。
このときの*Programmer*クラスを「サブクラス(子クラス)」、*Human*クラスを「スーパークラス(親クラス)」と呼ぶ。サブクラスはスーパークラスの機能(メソッド、フィールド)にアクセスすることができる。
プログラマのコンストラクタではスーパークラスのコンストラクタである「スーパーコンストラクタ」
を呼び出している(*super(name,age)*)。
*to_s*メソッドでは、スーパークラスの*to_s*メソッドを呼び出し、Humanクラスの文字列を結合して、
新たな文字列を生成している。これにより大幅な実装重複が削除ができた。
このとき、スーパークラスのメソッドを再定義することを「オーバーライド」と呼ぶ。上の例ではinitialize、to_sともにオーバーライドしていることになる。
またプログラマクラスと人間クラスの関係をIS-Aの関係と呼ぶ(Programmer is a Human. ただし逆は成り立たない)。

演習:

継承関係を持ったクラスをいくつか考え、実装せよ。
余裕があれば以下のJavaの演習の継承をRubyで再実装せよ。

- http://web-int.u-aizu.ac.jp/~yutaka/courses/javaone/ex_04.html
- http://web-int.u-aizu.ac.jp/~yutaka/courses/javaone/ex_05.html
