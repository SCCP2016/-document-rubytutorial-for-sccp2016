### 2.3 while式
C言語でも登場したループを表す制御構文のうち、本節ではwhlie式を紹介する。while式はrubyの中で最も単純な繰り返し構造であり、条件式が成立している間、被制御ぶの式を繰り返し評価し続ける。while式は以下のように書くことが出来る。

```ruby
# Rubyのwhile式、doは省略可能
while [条件式] do
  [被制御部]
end

# if式などと同様にwhile修飾子が存在している。
[被制御部] while [条件式]
```

whileもRubyでは式なので値を返す。基本的にwhileの返却値はnilだが、値つきでbreakした時のみnil以外の値を返すようになっている。

```ruby

x = 0
message = while true
  x += 1
  break 'x > 10' if x > 10
puts message  #=> x > 10
```