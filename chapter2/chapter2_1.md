### 2.1 if式
rubyにおけるif式の基本的な構文は以下の形になる。

```ruby
if [条件式] then
    [被制御式]
end

# 複数条件ある時のif式 (elseif ではないことに注意！)
if [条件式1] then
    [被制御式1]
elsif [条件式2] then
    [被制御式2]
elsif ...
    ...
else
    [被制御式n]
end
```

if式の構造を覚えたら、以下の例を試してみよう。

```ruby
# -*- coding: utf-8 -*-
# if.rb

x = 10
if x == 1 then
    puts '1'
elsif x < 5 then
    puts '5より小さい'
else
    puts '5以上'
end
```

もしelse節がなく、条件式単体の文を実行したい時には以下のように書くことができる。
```ruby
# if制御式の書き方
[被制御式] if [条件式]
```
```
irb(main):001:0> x=10
=> 10
irb(main):002:0> x=x*2+1 if x % 2 == 0
=> 21
irb(main):003:0> x=x*2+1 if x % 2 == 0
=> nil
irb(main):004:0> x
=> 21
```
非常に短くプログラムを書くことができるので、よく使われるテクニックのひとつである。

もし条件式に != を使う場合には、条件式が偽のときに実行されるunless構文を使うのも手だ。
```ruby
unless [条件式] then
    [被制御式]
end
```

Rubyではifは文ではなく、式として評価することができる。
文との違いを示すためにC言語との比較を以下に示す。

```c
// if_exp.c

int x, y; // 宣言が必要。
scanf("%d", &x);
if(x % 2 == 0){
    y = x * 2;     // 代入が逐一必要。
}else{
    y = x * 3;     // 代入が逐一必要。
}
printf("%d\n", y);
```

```ruby
# if_exp.rb

x = STDIN.gets.to_i # 標準入力を受け取り、整数に変換する。
y = if x % 2 == 0 then  # ifの結果をyに代入
    x * 2   # 式(右辺)のみを記述
else
    x * 3
end
puts y
```
以上の例は、xが偶数なら2倍、奇数なら3倍にして返すif式の結果をyに代入している。
Rubyの関数やifでは、最後に評価される値を結果として返していることがわかる。

if式の使い方が習得できているかの確認のために以下の問題を解いてみよう。

- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ITP1_2_A
- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ITP1_2_B

補足
```ruby
# 以下のように書くと空白区切りの文字を数字に変換しつつ、a,bに代入することができる。
a, b = STDIN.gets.split.map(&:to_i)
```

