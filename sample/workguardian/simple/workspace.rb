# JSON形式のファイルを読み込むためのライブラリをロードする
# JSONとはデータを交換するときに使われるフォーマットの一つで
# JavaScriptの一部をベースとした文法で記述する。
# 人間が記述しやすく、プログラムで読み取りやすいという特徴を持つ。
# 今回はワークスペースの設定ファイルのフォーマットに使う。
# 細かい文法についてはこちら -> https://ja.wikipedia.org/wiki/JavaScript_Object_Notation#.E8.A1.A8.E8.A8.98.E6.96.B9.E6.B3.95
require 'json'

# 設定ファイルを読み込んでディレクトリ構造を操作するクラス
# @work_root: ワークスペースのルートディレクトリ
# @conf: ロードした設定ファイル
class WorkSpace
  attr_reader :work_root

  # work_rootの設定と設定ファイルのロード
  # work_root: ワークスペースのルートディレクトリ
  def initialize(work_root)
    @work_root = work_root
    @conf = load_configuration(work_root)
  end

  # ワークスペース上の設定ファイルを読み込んで結果を返す
  # wook_root: ワークスペースのルートディレクトリ
  # return: ロードした設定のハッシュ
  def load_configuration(work_root)
    raise 'Configuration file has not found.' if !WorkSpace.configuration_file?(work_root)
    json = open(work_root + '/workguardian.json')
    begin
      # JSON形式のファイルをロードして一つのハッシュオブジェクトに格納して返す
      # 文法が間違っている場合は例外を投げる
      JSON.load(json)
    rescue
      raise 'Configuration file loading has failured.'
    ensure
      json.close
    end
  end

  # 読み込んだ設定ファイルの演習の項目を返す
  # return: 演習の設定ハッシュの配列
  def exercises
    @conf['exercises']
  end

  # 演習名の配列を返す
  # return: 演習名の配列
  def exercise_names
    # mapメソッドは配列全てにブロックを適用して、ブロックの戻り値を改めて配列に格納する。
    # [1, 2, 3].map{|num| num.to_s} #=> ["1", "2", "3"]
    exercises.map{|exe| exe['name']}
  end

  # 設定ハッシュからExerciseオブジェクトを生成する
  # exercise_hash: 生成する演習の設定ハッシュ
  def generate_exercise(exercise_hash)
    name = exercise_hash['name']
    assignments = exercise_hash['assignments']
    Exercise.new(name, @work_root, assignments)
  end

  # 一つの演習について、提出していない課題を探して返す
  # return: 提出していない課題の配列
  def find_unassigned_works_in(exercise_number)
    # 存在演習番号の場合は例外を投げる
    raise "Exercise number required from 0 to #{exercises.size - 1}" if exercises.size - 1 < exercise_number || exercise_number < 0
    exercise = generate_exercise(exercises[exercise_number])
    exercise.find_unassigned_works
  end

  # 設定ファイル通りに演習ディレクトリが作成されているかどうかを判定する
  # return: 判定結果
  def directory_structure?
    entries = Dir::entries(@work_root)
    exercise_names.all?{|exe| entries.any?{|entry| entry == exe}}
  end

  # 存在しない演習ディレクトリを探す
  # return: 存在しない演習ディレクトリ名の配列
  def find_unexisted_exercises
    entries = Dir::entries(@work_root)
    exercise_names.select{|exe| !entries.any?{|entry| entry == exe}}
  end

  # 設定ファイル通りに演習ディレクトリを作成する
  # return: 新規に作成した演習ディレクトリ名の配列
  def create_directory_structure
    for exercise in find_unexisted_exercises
      Dir::mkdir(@work_root + '/' + exercise)
    end
  end

  # ワークスペースに設定ファイルが存在するかどうかを判定する
  # return: 判定結果
  def self.configuration_file?(work_root)
    Dir::entries(work_root).any?{|element| element == 'workguardian.json'}
  end
end

# 演習内の課題の提出状況についてのクラス
class Exercise

  # @name: 演習名
  # @exe_root: 演習のルートディレクトリ(演習名のディレクトリ)
  # assignments: 課題名の配列
  def initialize(name, work_root, assignments)
    @name = name
    @exe_root = work_root + '/' + name
    @assignments = assignments
  end

  # 提出済みの課題を返す
  # return: 提出済みの課題の配列
  def find_assigned_works
    @assignments.select{|assignment| Dir::entries(@exe_root).any?{|elem| elem == assignment} }
  end

  # 未提出の課題を返す
  # return: 未提出の課題の配列
  def find_unassigned_works
    @assignments.select{|assignment| !Dir::entries(@exe_root).any?{|elem| elem == assignment} }
  end
end
