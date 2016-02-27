## 4.2 シンボル

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

シンボルはハッシュのキーに文字列リテラルの代わりに使うことが多い。