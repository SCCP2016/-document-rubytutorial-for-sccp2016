## 4.1 例外の捕捉

プログラムの実行中に処理が続行不可能になる異常な状態になる場合がある。そのような状態に陥った時に処理を断ち切って状況に合わせてその時用の処理をさせたい場合がある。例外処理はその時に必要となる。

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

例えば、テキストファイルの内容をそのまま別のファイルにコピーする時に、読み込むファイルのあるディレクトリが無ければ処理は続行できず、エラーを発生させてしまう。以下の例は例外処理を利用してエラーを回避したコードである。

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

これでエラーを発生させずに実行は終了するが、ファイルオープンに失敗した時にディレクトリを作成するだけで終了してしまう。ディレクトリを作成した後にbeginの処理を再度実行したい時には、rescue内にretryを書くと良い。

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

また、補足だがbegin...endも式である。その値は式内で最後に評価された式の値になる。