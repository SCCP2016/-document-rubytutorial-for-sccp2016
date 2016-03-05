## 3.4 ハッシュの生成とメソッド

ハッシュはプログラミング言語によってはディクショナリーと呼ばれ、その名の通り、キーとなるオブジェクトを元にしてそれに対応する値を探して返す辞書のような構造になっている。
配列は添字(整数)をキーとして別のオブジェクトに対応付けるハッシュのようなオブジェクトと言えるが、配列は要素の順番を大切にしているのに対し、ハッシュはキーとなるオブジェクトが順番を持てるものとは限らないのであまり重要とはされていない。

またRubyでは、シンボルという文字列(のように見えるもの)をキーとしてとしてハッシュを書くのがベターとされている。

以下にハッシュの構築方法と、アクセス方法を示す。

```ruby
hash = {one: 1, two: 2, three: 3}
p hash[:one] #=> 1
p hash[:two] #=> 2
hash[:five] = 5 # 新しいキーと値の組み合わせ。
p hash       #=> {:one=>1, :two=>2, :three=>3, :five=>5}
```

Rubyではメソッド名、変数名や先の章で説明するクラス名などの名前は全て整数で管理している。この名前に対応した整数を表現したものがシンボルである。

```
irb(main):013:0> :ruby
=> :ruby
irb(main):014:0> :ruby == :ruby
=> true
irb(main):015:0> :ruby.object_id == :ruby.object_id
=> true
irb(main):016:0> "ruby" == :ruby
=> false
irb(main):017:0> "ruby".object_id == :ruby.object_id
=> false
irb(main):018:0> "ruby".object_id == "ruby".object_id
=> false
```

上のハッシュをREPL上で宣言して、実際に以下のコマンドを打ってハッシュの挙動を確かめてみよう。

```ruby
# キーを指定して、値を参照する
p humane_studies["Philosophy"]  # => "Aoki"
# 存在しないキーの場合
p humane_studies["Linear Algebra"] #=> nil
# 既存のキーの更新
p humane_studies["Philosophy"] = ["Ohta", "Aoki"]
# 新しいキーの登録
book_to_author["Written expression"] = "Sawa"
```

ハッシュも多くのメソッドを備えているが、とりあえずは配列の要領でリファレンスを見てもらうことにする。

- http://docs.ruby-lang.org/ja/2.1.0/class/Hash.html

ハッシュにも配列同様にイテレータをサポートしているメソッドを持っている。

```ruby
hash = {Mike: 18,  John: 19,  Jakky: 28,  Mika: 20,  Karen: 22,  Mary: 19,  Chris: 28,  Mikky: 25 }
hash.each do |name, age|
  puts "#{name}: #{age}" if name[0] == "M" || name[0] == "C" # 頭文字がMとCの人だけ表示する。
end
```
ハッシュを自由自在に使えると応用が効きやすいので、覚えると良い。
以下にハッシュが使えるような問題を以下に用意した。少々難しい問題かもしれないが、是非こちらも挑戦してみて欲しい。

- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0088
- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0105
- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0201
- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0242