## 9.1 標準入出力

標準入出力とは、シェルプログラムが提供しているプログラムの入出力を標準化したもの(ストリーム)のことである。
C言語ではscanfなどの関数で標準入力、printfなどの関数で標準出力を行っていたが、Rubyにもこれらに相当するメソッドが存在する。このページではそのメソッドを解説する。

- 標準入力

Rubyには標準入力を一行読み込むgetsメソッドが標準で定義されている。

```shell
irb(main):001:0> gets
I am a student
=> "I am a student\n"
```

しかしgetsだけでは最後に改行が含まれてしまうので、普通はchompメソッドを使って改行を取り除く。

```shell
irb(main):001:0> gets.chomp
I am a student
=> "I am a student"
```

C言語のscanf関数のように空白区切りで取得する時はsplitメソッドを使う。

```shell
irb(main):001:0> gets.chomp.split(' ')
I am a student
=> ["I", "am", "a", "student"]
```

このgetsメソッドを使って、標準入力に入力された数字を全て足し合わせるsum_inputメソッドを定義すると次のようになる。

```ruby
def sum_input
    gets.chomp.split(' ').map(&:to_i).inject(:+)
end
```

ブロック付きメソッドについては3.2を参照。また、mapメソッドは配列の全てにメソッドを適用するメソッド、injectメソッドは配列の先頭から順番にメソッドを適用して一つの値を求めるメソッドである。

- 標準出力

標準出力については資料内でも頻繁に登場したが改めて紹介する。
よく使う標準出力を行うメソッドはprint, puts, pの3つである。

```ruby
print "Ruby"
#=> Ruby

puts "Ruby"
#=> Ruby\n

p "Ruby"
#=> "Ruby"
```

printは引数で渡した文字列をそのまま出力する。putsは最後に改行文字を追加して表示するので、CUIツールを書く場合には一番使うメソッドである。pメソッドは引数で渡したオブジェクトを出力する。

```ruby
array = [1, 2, 3]
p array
#=> [1, 2, 3]

class Animal
    def initialize(name, age)
        @name = name
        @age = age
    end
end

dog = Animal.new('Dog', 4)
p dog
#=> #<Animal:0x007fbacb90b5e0 @name="Dog", @age=4>
```

また、print、putsメソッドは渡したオブジェクトのto_sメソッドを使って文字列に変換してから出力するので、渡すオブジェクトにはto_sメソッドが定義されていなければならない。

```ruby
class Animal
    def initialize(name, age)
        @name = name
        @age = age
    end
    def to_s
        "#{@name}: #{@age}"
    end
end

dog = Animal.new('Dog', 4)

print dog
#=> Dog: 4

puts dog
#=> Dog: 4\n
```