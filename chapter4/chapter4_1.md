## 4.1 ハッシュの生成とメソッド

以下にハッシュの構築方法と、アクセス方法を示す。

```ruby
hash = {one: 1, two: 2, three: 3}
p hash[:one] #=> 1
p hash[:two] #=> 2
hash[:five] = 5 # 新しいキーと値の組み合わせ。
p hash       #=> {:one=>1, :two=>2, :three=>3, :five=>5}
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