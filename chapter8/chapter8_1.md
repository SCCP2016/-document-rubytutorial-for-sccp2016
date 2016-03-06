## 8.1 RubyGemsの概要と使い方

RubyGemsとは、Rubyのパッケージマネージャのことで、ちょうどapt-getやaptitude、yumのようなLinuxのパッケージマネージャのRuby版のようなツール、システムのことである。

Rubyで作られたライブラリやフレームワークといったプログラムパッケージをgemという名前で管理して、それぞれのユーザが自分の環境にインストールして自分のプログラムに活用することが目的である。

まず、RubyGems利用するためにはgemコマンドを環境にインストールしなければならない。OSごとのパッケージマネージャからインストールするか、[RubyGemsのソースコード](https://rubygems.org/pages/download)を直接ビルドしてインストールすると良い。これ以降はgemコマンドが使える状態という前提で説明していく。

gemコマンドを利用してgemをインストールする時には以下のコマンドを実行する。

```
gem install [gem名]
```

では実際にTitleizeというライブラリをインストールして利用してみよう。
Titleizeとは文字列を単語ごとに区切ってそれぞれの頭文字を大文字に変換する、titleizeメソッドを提供するgemライブラリである。

```
sudo gem install titleize
```

gem installはroot権限が必要な領域への書き込みを行うので、root権限を持っていなければsudo(スーパーユーザでの実行)が必要である。

次に、インストールしたパッケージを使ってプログラムを書いてみる。

```ruby
require 'titalize'

puts 'this is the lecture text of ruby for SCCP2016'
#=>   this is the lecture text of ruby for SCCP2016

puts 'this is the lecture text of ruby for SCCP2016'.titleize
#=>   This Is the Lecture Text of Ruby for SCCP2016
```

requireはC言語での#includeの役割をするが、Rubyのrequireは構文ではなくメソッドである。