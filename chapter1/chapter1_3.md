## 1.3 色々な型

Rubyは純粋なオブジェクト指向型のプログラミング言語なので、プログラム内で扱う値の全てがオブジェクト(オブジェクトについては6章)である。
C言語にはint型、float型、char型などの型が存在して、Rubyにもそれらに相当する型(クラス)が存在する。ここではその一部を紹介する。

### Fixnum

Fixnum型は整数値を扱う型である。扱える数字の大きさは環境にもよるが、ほとんどの環境では(2^31)-1から-(2^31)までの整数値を扱うことができる。

```shell
irb(main):001:0> 1
=> 1
irb(main):002:0> 900
=> 900
irb(main):003:0> -1234
=> -1234
```

Fixnumには整数値の演算をするためのメソッドが多数定義されている(Rubyでは演算子もメソッド。メソッドについては5章)。

- 四則演算メソッド

```ruby
1 + 2
#=> 3

80 - 90
#=> -10

5 * 4
#=> 20

8 / 5
#=> 1 (小数点以下は切り捨て)
```

- 比較演算メソッド

```ruby
1 > 2
#=> false

50 >= 50
#=> true

8 < 9
#=> true

0 <= -3
#=> false

20 == 20
#=> true
```

- ビット演算メソッド

```ruby
# OR
2 | 5 # 010 | 101
#=> 7 (111)

# AND
6 & 5 # 110 & 101
#=> 4 (100)

# XOR
5 ^ 3 # 101 ^ 011
#=> 6 (110)

# 左ビットシフト
2 << 2
#=> 8

# 右ビットシフト
4 >> 1
#=> 2
```

- その他のメソッド

```ruby
# 絶対値
-30.abs
#=> 30

# 累乗
6 ** 3
#=> 216

# 剰余
11 % 5
#=> 1
```

### Bignum

Fixnum型はある程度の上限があったが、Bignum型はほぼメモリの許す限り大きな整数を扱うことができる。Rubyは動的型付け言語なのでFixnumとBignumは実行時に自動的に決まるので特にコーディング時に使い分けをする必要はない。
また、BignumにもFixnumと同じメソッドが定義されているので、同様の計算を行うことができる。

### Float

Float型は浮動小数点数を扱う型である。Floatという名前だが実装はC言語のdoubleで、その精度は環境に依存する。
Fixnumと同じメソッドに加えて小数点数ならではのメソッドがいくつか定義されている。

```ruby
# 自分と等しいかそれ以上の値を持つ整数を返す
1.1.ceil
#=> 2

# ∞または-∞の時にtrueを返す
(1.0/0).infinite?
#=> true (数学的には微妙な判定)

# 四捨五入した結果を返す
3.14.round
#=> 3
```

### TrueClass, FalseClass

TrueClass型はtrue、FalseClass型はfalseを扱う型である。trueは肯定的な意味(真)、falseは否定的な意味(偽)を持つ値で、条件分岐等に使われる。Rubyのtrue、falseを扱う型は他の言語と比べて特殊で、両方をまとめて扱う型は存在しない。なので、trueとfalseはそれぞれ違う型である。
TrueClass、FalseClassには論理演算をするメソッドが定義されている。

```ruby
# OR
true || false
#=> true

# AND
true && false
#=> false

# XOR
true ^ false
#=> true
```

### String

String型は文字列を扱う型である。文字列リテラル("ruby"や'ruby'など、クォーテーションで囲われた文字列)を記述すると自動的にString型として扱われる。C言語では文字列を文字の配列を使って表現したが、RubyのString型は文字の配列とは別物である。
String型には以下のようなメソッドが定義されている。

```ruby
# 文字列の連結をする
'Hello, ' + 'world!'
#=> "Hello, world!"

# 文字列が一致すればtrue
'ruby' == 'ruby'
#=> true

# 文字列の長さを返す
'ruby'.size
#=> 4

# 部分文字列を取り出す
'ruby is a powerful language'[12]
#=> "o" (文字数が１の文字列)

# 文字数を指定した部分文字列の取り出し
'ruby is a powerful language'[12, 4]
#=> "ower"

# 文字列を分割する
'ruby is a powerful language'.split(' ')
#=> ["ruby", "is", "a", "powerful", "language"]
```

Rubyは動的型付けの言語なので、実行するまで値(オブジェクト)の型は決まらないが、実行時に値に*.class*をつけてその値の型を参照することができる。

```ruby
1.class
#=> Fixnum

9999999999999999999999999.class
#=> Bignum

3.6.class
#=> Float

false.class
#=> FalseClass

"ruby".class
#=> String
```
