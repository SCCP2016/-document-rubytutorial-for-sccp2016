### 5.2 デフォルト引数

関数を利用するときに普段は省略したいが、あるときはオプションとして使いたい引数などがあるとする。そういう時はデフォルト引数を用いる。

```ruby
def even_double_plus(x, t=0)
  if x % 2 == 0 then
    x * 2
  else
    x + t
  end
end

even_double_plus(3)
=> 3
even_double_plus(3, 5)
=> 8
```

演習:

名前を入力したらイニシャル(文字列)を返す関数*initial*を作れ。
ただし、ミドルネームも考慮せよ。

```ruby
initial('Barack', 'Obama')
=> B.O
initial('John', 'F', 'Keneddy')
=> J.F.K
```

Rubyで関数を書く中で、デフォルト引数ではどうにも上手く行かない場合は、前回やったハッシュを引数として使うと、
より柔軟に関数が書けるので覚えておこう。
