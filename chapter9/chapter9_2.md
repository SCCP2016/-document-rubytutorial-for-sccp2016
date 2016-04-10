## 9.2 ファイル入出力

プログラム上でファイル入出力を行う際は次のような流れで行う。

```shell
1) ファイルオープン
2) 内容読み出し、または書き込み
3) ファイルクローズ
```

これに対応するRubyのメソッドはそれぞれ以下通り。

```shell
1) open(file_name, mode)
2) read(), write(text)
3) close()
```

では1) ~ 3)のメソッドを使って、テキストファイルのコピーをするメソッドを定義してみよう。

```ruby
def copy_file(from, to)
    # 1)
    origin = open(form, 'r')
    new_file = open(to, 'w+')

    # 2)
    context = origin.read
    new_file.write(context)

    # 3)
    origin.close
    new_file.close
end
```

openメソッドのmodeはファイルオープンの目的に応じて変える必要がある。

- 'r'   読み込みモード
- 'r+'  読み込み+書き込みモード
- 'w'   新規作成+書き込みモード
- 'w+'  新規作成+読み込み+書き込みモード
- 'a'   追加書き込みモード
- 'a+'  読み込み+追加書き込みモード

wの新規作成は、openメソッドの引数に指定したファイル名のファイルが存在しなかった場合に空のファイルを新規作成するという意味である。

### 演習問題
複数のファイル名original_filesの内容を連結してnew_fileに書き込むメソッドconcat_filesを作成しなさい。new_fileとファイル名が同じファイルが存在する場合はその内容を保持して後ろに書き足すこと。

```ruby
concat_files(original_files, new_file)
```