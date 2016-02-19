### 2.2 case式
rubyにおけるcase式は、C言語におけるswitch-case文に相当するものであり、値による多岐分岐を提供してくれている。

```ruby
# Rubyのcase式
case [変数]
when [値] then
  [処理]
when [値] then
  [処理]
...
else
  [処理]
end
```
上のcase式では、まずcaseの後に置かれた[変数]が評価され、次にその値に対応するwhen節が選ばれた後にthen節が実行され、
最後に評価された式がcase式全体の値になり、返却される。このcase式もif式と同じく、区切りが明確であればthenは省略可能である。

Rubyのcase式は整数・文字、だけでなく任意の型を記述することができる。
非常に面白い例として範囲をあらわすRange型を使用してみる。

case.c
```ruby
# -*- coding: utf-8 -*-

int x;
while(1){
	scanf("%d", &x);
	switch(x){
		case 1:
		case 2:
		case 3:
			printf("0~3の間");
		...
		default:
			printf("範囲外なので終了。");
			break;
	}
}
```

case.rb
```ruby
# -*- coding: utf-8 -*-

puts '0~10の間の数字を入力してください。(範囲の外に出たら終了。)'
loop{ # 無限ループをするメソッド
  case STDIN.gets.to_i
  when 0..3   #  範囲をあらわすRange型
    puts '0~3の間'
  when 4..7
    puts '4~7の間'
  when 8..10
    puts '8~10の間'
  else
    puts '範囲外に出たので終了します。'
    break
  end
}
```
case式の使い方を覚えたら次の問題を解いてみよう。

- http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ITP1_4_C 