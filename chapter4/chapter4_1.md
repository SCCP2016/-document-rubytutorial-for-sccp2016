## 4.1 例外の捕捉

プログラムの実行中に処理が続行不可能な異常状態になることがある。そのような状態に陥った時に処理を断ち切って状況に合わせてその時用の処理をさせたい場合がある。例外処理はその時に必要となる。

```ruby
begin
  # 例外が発生しうる処理

rescue
  # 例外が発生した場合の処理

else
  # 例外が発生しなかった場合の処理

ensure
  # 例外が発生したかどうかに関わらず実行される処理

end
```
rescue、else、ensure節のいずれも不要であれば省略可能である。

例外処理を利用したプログラムの例を見てみよう。例えば、あるテキストファイルの内容をそのまま別のファイルにコピーするプログラムを書くとすると、読み込むファイルのあるディレクトリが無ければ処理は続行できず、エラーを発生させてしまう。

```ruby
# open(file_name, mode)メソッドは、file_nameファイルをmodeで指定したモードで開く。
# wまたはw+を指定すると、file_nameファイルがなかった時にファイルを新規作成する。
input_file = open('text/input.txt', 'w+')
output_file = open('text/output.txt', 'w')

# しかし、ファイルの属するディレクトリ(この場合text/)がない場合は例外を発生させ、
# 以下の処理が実行される前にエラーになって終了してしまう。
output_file.write("==Copy start==\n")
output_file.write(input_file.read)
output_file.write("==Copy end==\n")
input_file.close
output_file.close
puts 'finish.'
```

以下の例はそのプログラムを、例外処理によってエラーの発生を回避させたコードである。

```ruby
begin
  # ファイルをオープン
  input_file = open('text/input.txt', 'w+')
  output_file = open('text/output.txt', 'w')

rescue
  # ファイルオープンに失敗したらディレクトリを作成
  Dir::mkdir('text')

else
  # ファイルオープンに成功したらコピーしてファイルクローズ
  output_file.write("==Copy start==\n")
  output_file.write(input_file.read)
  output_file.write("==Copy end==\n")
  input_file.close
  output_file.close

ensure
	# 処理が終了したらそのことを出力して終了
  puts 'finish.'

end
```

これでエラーを発生させずに実行は終了するが、ファイルオープンに失敗した時にディレクトリを作成するだけで終了してしまう。rescue節実行後(ディレクトリの作成後)にbeginの処理を再度実行したい時には、rescue節内にretryを書くと良い。

```ruby
begin
  input_file = open('text/input.txt', 'w+')
  output_file = open('text/output.txt', 'w')

rescue
  Dir::mkdir('text')
  retry  # retryを追加

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

また、補足だが、例外処理のbegin...endも式である。その値は式内で最後に評価された式の値になる。

#### 演習問題

二つの整数を引数にとり、A/Bを返すメソッドがある。
```ruby
def div(a, b)
  a / b
end

p div(4, 2)
#=> 2

p div(9.0, 8)
#=> 1.125
```
- div(5, 0)を実行してみよ
- 例外処理を使って、div(5, 0)を実行した時に警告を表示して正常に関数呼び出しが終了するようにdiv関数を書き換えなさい。そのときの戻り値は指定しない。