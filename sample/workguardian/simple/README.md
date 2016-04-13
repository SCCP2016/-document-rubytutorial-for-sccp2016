# WorkGuardianの使い方とコードの説明

## 概要

WorkGuardianは演習課題用のディレクトリを作成、監視して課題の進捗状況を管理するCUIツールである。
ディレクトリの作成はworkguradian.jsonに記述した通りに行い、進捗状況の確認もこの設定ファイルを使って行われる。

## 使い方

WorkGuradianには3つのコマンドがある。

### init (-workroot [dir_name])

dir_nameに設定ファイルがなければ、デフォルトの設定ファイルをdir_name以下に作成する。

### create (-workroot [dir_name])

dir_nameに設定ファイルがあれば、読み込んで不足分の演習用ディレクトリを作成する。

### check (-workroot [dir_name]) (-exercise [exe_number])

dir_nameに設定ファイルがなければ、警告を表示する。

設定ファイル通りに演習用ディレクトリが作成されていなければ、警告を表示する。

exe_numberに指定があれば、その演習について課題ファイルが作成されているかどうかを表示する。

exe_numberに指定がなければ、一つ目の演習から順に課題ファイルが作成されているかどうかを判定し、不足があればそれを表示する。

## コード中に使われているメソッド等に関しての補足

### app.rb

- array.drop(number)

arrayの先頭からnumber個除いた配列を返す。

```ruby
[1, 2, 3, 4].drop(2)
#=> [3, 4]
```

- hash1.update(hash2)

hash1とhash2を合わせた新しいHashを返す。同じキーを持つ要素についてはhash2を優先する。

```ruby
hash1 = {'-workroot' => Dir::pwd, '-exercise' => ''}
hash2 = {'-exercise' => '2'}

hash1.update(hash2)
#=> {'-workroot' => Dir::pwd, '-exercise' => '2'}
```

### command.rb

- \_\_dir\_\_

実行ファイルのディレクトリを返す。

```ruby
# /ruby/is/a/powerful/language/app.rb
__dir__
#=> /ruby/is/a/powerful/language/
```

- nil

空の状態を示す値。C言語のnullのようなもの。

- array.find(&block)

arrayの全ての要素に対して、Bool値を返すblockを適用して、trueが返る最初の要素を返す。

```ruby
[1, 2, 3, 4, 5].find{|num| num % 2 == 0}
#=> 2
```

### workspace.rb

- array.map(&block)

arrayの全ての要素に対して、blockを適用して返ってきた値の配列を返す。

```ruby
[1, 2, 3, 4, 5].map{|num| num.to_s}
#=> ["1", "2", "3", "4", "5"]
```

- array.all?(&block)

arrayの全ての要素に対してblockを適用し、全てtrueが返ってきたらtrue、一つ以上falseならfalseを返す。

```ruby
[1, 2, 3, 4, 5].all?{|num| num % 4 == 1}
#=> false
```

- array.select(&block)

arrayの全ての要素に対して、Bool値を返すblockを適用して、trueが返る全ての要素の配列を返す。

```ruby
[1, 2, 3, 4, 5].find{|num| num % 2 == 0}
#=> [2, 4]
```

- array.all?(&block)

arrayの全ての要素に対してblockを適用し、一つ以上trueが返ってきたらtrue、全てfalseならfalseを返す。

```ruby
[1, 2, 3, 4, 5].any?{|num| num % 4 == 1}
#=> true
```