## 4.2 メッセージの受け取りと例外の特定

4.1では例外が発生するとはどういうことか、また、例外を捕捉する方法について説明した。実は、例外は実行状態の異常を捕捉するための単なるシグナルではなく、立派なオブジェクトである(オブジェクトについてはchapter6で解説)。例外時に投げられるオブジェクトにはその例外の発生した理由が、そのオブジェクトの型やオブジェクトの持つメッセージに込められているので、受け取ることで例外発生後の処理に役立てることができる。

例外処理はbegin...end式で記述されるが、実際に例外を捕捉するのはrescue節である。例外オブジェクトを受け取る時にはこのrescue節を以下のように書き換える。

```ruby
rescue [例外オブジェクトの型(任意)] => [例外オブジェクトを格納する変数]
```

例えば4.1の、テキストファイルの中身をコピーするプログラムの例で、例外メッセージを受け取りたい時には以下のように書き換えると良い。

```ruby
begin
  input_file = open('text/input.txt', 'w+')
  output_file = open('text/output.txt', 'w')

rescue => e # 例外オブジェクトを受け取るように追記
	p e       # オブジェクトの情報を表示するように追加
  Dir::mkdir('text')
  retry

else
  output_file.write("==Copy start==\n")
  output_file.write(input_file.read)
  output_file.write("==Copy end==\n")
  input_file.close
  output_file.close

ensure
  puts 'finish.'

end
```

このプログラムを、カレントディレクトリにtextディレクトリがない状態で実行すると以下のように表示される。

```
#<Errno::ENOENT: No such file or directory - text/input.txt>
finish.
```

Errno::ENOENTオブジェクトをrescue節で捕捉できていることが分かる。Errno::ENOENTオブジェクトはシステムコール(OSのネイティブな機能を呼び出すこと)で例外が発生したときに投げられる例外オブジェクトである。また、コロン(:)の後に続く文字列は例外の内容を説明しているメッセージで、例外オブジェクトは必ずこのメッセージを持っている。

では、次に例外の特定をしてみよう。

openメソッドはファイルオープンに失敗したときにErrno::ENOENT型の例外オブジェクトを投げることが分かったので、例外がErrno::ENOENT型のもののみを捕捉するように書き換えてみる。

```ruby
begin
  input_file = open('text/input.txt', 'w+')
  output_file = open('text/output.txt', 'w')

rescue Errno::ENOENT => e # Errno::ENOENTオブジェクトのみを受け取るように追記
	p e
  Dir::mkdir('text')
  retry

else
  output_file.write("==Copy start==\n")
  output_file.write(input_file.read)
  output_file.write("==Copy end==\n")
  input_file.close
  output_file.close

ensure
  puts 'finish.'

end
```

このように記述することで特定の型の例外オブジェクトのみを捕捉することができる。
