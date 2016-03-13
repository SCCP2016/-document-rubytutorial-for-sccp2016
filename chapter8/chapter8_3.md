## Bundlerからツールを使う

8.2ではgemをプロジェクトごとに管理するBundlerというツールについて解説した。このページではBundlerのもう少し発展した使い方について解説していく。

8.2で触れたが、Bundlerもgemの一つであり、RubyGemsを使ってインストールできるツールである。では、Bundlerでプロジェクトにインストールされたツールはどのように使用するのだろうか？

Bundlerには、プロジェクトにインストールされたツールを対象にしてコマンドを実行するためのコマンドが用意されている。

```
bundle exec [コマンド]
```

例えばプロジェクトにreekというgemをインストールして使用するとする。

```ruby
# Gemfile
source "https://rubygems.org"

gem "reek"
```

reekはRubyのコード内で、メソッドの中身が冗長だったりネストが深いコードを見つけて報告してくれるツールである。ではservice.rbをreekにかけてみよう。

```
$ reek service.rb
zsh: command not found: reek
```

環境ではなくプロジェクトにインストールしたので当然だが、「reekコマンドが見つからない」と言われてしまった。では、今度はbundle execを使ってみる。

```
$ bundle exec reek service.rb
service.rb -- 1 warning:
  [4]:NestedIterators: call_service contains iterators nested 3 deep [https://github.com/troessner/reek/blob/master/docs/Nested-Iterators.md]
```

今度はプロジェクトにインストールしたreekを実行できた。プロジェクトにインストールしたgemのツールを使う時にはこのようにして実行する。