## 1.1 はじめに
Rubyは日本人、まつもとゆきひろ(通称Matz)の手によって開発された、オブジェクト指向・スクリプト言語である。
この２つの考え方が、会津大学の主要言語であるC言語ではなく、Rubyを採択した大きな理由の一つである。

スクリプト言語(またはインタプリタ言語)は、コンピュータにとって実行可能な状態にする手順「コンパイル」を
挟まずに、インタプリタにより逐次解釈・実行を行う言語形式のことを言う。簡単に図で表すと以下のようになる。

ソースコード → コンパイラ [変換] → 実行可能ファイル [実行]

スクリプト → インタプリタ [逐次解釈・実行]

コンパイラによるコンパイル手順を挟まないので、プログラム作成から実行までの手順が簡単であることが大きな特徴として挙げられる。
また厳密な定義ではないが、ユーザが明示的に型を付ける(静的型付)のとは違い、型を明示的に付けない(動的型付)ので、
簡単なプログラムであれば短いプログラムで書くことができるのも、特徴として挙げられる。
一方コンパイル言語の実行ファイル(機械語・アセンブリ言語)と比べて逐次解釈を行うので実行速度が比較的遅いことや、
型が無いことで複雑に成る程プログラムが読み難くなることが欠点として挙げられるケースが多い。

オブジェクト指向は現在、多くのプログラミング言語で採用されている、プログラムを構築する上での考え方(パラダイム)の一つである。
オブジェクト指向では、値をモノ(オブジェクト)として考える。言語によって考え方が異なるケースがあるが基本的には、
オブジェクトは状態(変数)と振る舞い(関数)を持つ構造のことである。このような構造を持つことで、
プログラムの変更に対して強固になる・再利用が容易になる・プログラムの簡略化ができる、などの利点を得ることができる。
SCCPでは、この考え方を主に学びながらアプリケーション作りに役立てていく。