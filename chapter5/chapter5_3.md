### ブロック付きメソッドの定義

ブロック付きメソッドの使い方については3.2で解説した。今回はその定義の仕方について解説する。

初めに、指定回数だけブロックを実行する、以下のような*times*メソッドを実装してみよう。

```ruby
times(4){|n|
	print "#{n}Ruby"
}
#=> "1Ruby2Ruby3Ruby4Ruby"

times(-1){|n|
	print "#{n}SCCP"
}

#=> (None)
```

*times*メソッドの実装例は以下の通りである。

```ruby
# (1)
def times(n)
	for i in 1..n
		yield n
	end
end

# (2)
def times(n, &block)
	for i in 1..n
		block.call(n)
	end
end
```

(1)では*yield*という、**ブロックを実行するメソッド**を使って定義している。(2)では*yield*メソッドを使わずに、名前に*&*を付けた引数を置く方法で実現している。また、(2)の実装から分かるように、ブロック自体も暗黙的に引数としてメソッドに渡されている。
