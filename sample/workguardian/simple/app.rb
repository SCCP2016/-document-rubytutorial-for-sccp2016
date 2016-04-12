# WorkGuardian
# 各演習(課題)用のディレクトリを自動生成して、課題の作成を監視します。

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

# 全てのコマンドの親クラス(スーパークラス)
class Command
  # コマンドの実行する
  def run(args)
  end

  # コマンドの実行に失敗したときにhelpを表示する
  def help
  end

  # 許容する引数の数
  def args_num
  end

  # コメンド名
  def self.name
  end

  # runメソッドに渡すデフォルトの引数
  def self.default_args
  end

  # 不正な引数の場合に例外を投げる
  def raise_if_errored_args(args)
    raise "Required #{args_num} args, but #{args.size}." if !args?(args)
  end

  # 正常な引数かどうかを判定する
  def args?(args)
    args.size >= args_num
  end
end

# 定義されていないコマンドを渡された時のためのコマンド
class UndefinedCommand < Command
  def run(args)
    puts 'Undefined Command'
  end

  def help
    ''
  end

  def args_num
    0
  end

  def self.name
    'undefined'
  end

  def self.default_args
    {}
  end
end

# ディレクトリにデフォルトの設定ファイルを設置してワークスペースを初期化するコマンド
class InitCommand < Command
  def run(args)
    raise_if_errored_args(args)
    work_root = args['-workroot']

    if WorkSpace.configuration_file?(work_root)
      puts "This workspace has initialized."
    else
      copy_conf_file(work_root)
      puts 'Initialize succeed.'
    end
  end
  
  # デフォルトの設定ファイルをwork_rootに設置する
  # work_root: 設定ファイルを設置するディレクトリ
  def copy_conf_file(work_root)
    # __dir__ return a string of directory on this ruby file.
    default = open(__dir__ + '/default.json', 'r')
    work_conf = open(work_root + '/workguardian.json', 'w+')
    work_conf.write(default.read)
    default.close
    work_conf.close
  end

  def help
    puts '*COMMAND FORMAT*'
    puts 'wgd init (-workroot [dir_name])'
    puts '-- "init" command will generate workguardian.json for configure workspace'
  end

  def args_num
    1
  end

  def self.name
    'init'
  end

  def self.default_args
    {'-workroot' => Dir::pwd}
  end
end

# 演習ディレクトリを作成するコマンド
class CreateCommand < Command
  def run(args)
    raise_if_errored_args(args)
    work_root = args['-workroot']
    workspace = WorkSpace.new(work_root)
    created_exercises = workspace.create_directory_structure
    created_exercises.each{|exe| puts "Create #{work_root + '/' + exe}."}
  end

  def help
    puts '*COMMAND FORMAT*'
    puts 'wgd create (-workroot [dir_name])'
    puts '-- "create" command will create directory structure.'
  end

  def args_num
    0
  end

  def self.name
    'create'
  end

  def self.default_args
    {'-workroot' => Dir::pwd}
  end
end

# ツール全体に関係する項目について確認するコマンド
class CheckCommand < Command
  def run(args)
    work_root = args['-workroot']
    exercise_number = args['-exercise']

    look_configure_file(work_root)
    workspace = WorkSpace.new(work_root)
    look_directory_structure(workspace)
 
    if exercise_number
      look_unassigned_works(workspace, exercise_number.to_i)
    else
      for i in 0..workspace.exercises.size
        look_unassigned_works(workspace, i)
      end
    end
  rescue => e
    puts e.message
  end

  # condがfalseを返した場合に例外を返す
  # cond: 条件式
  # message: 例外に含めるメッセージ
  def finish_until(cond, message)
   raise message if !cond
  end

  # 設定ファイルがwork_rootに存在するかどうかを判定する
  # work_root: ワークスペースのルートディレクトリ
  def look_configure_file(work_root)
    finish_until(WorkSpace.configuration_file?(work_root),"Configuration file has not found.")
  end

  # 設定ファイル通りに演習ディレクトリが作成されているかどうかを判定する
  # workspace: 判定したいワークスペースのWorkSpaceオブジェクト
  def look_directory_structure(workspace)
    finish_until(workspace.directory_structure?, "This workspace has not created directory structure.")
  end

  # 未提出の課題があるかどうかを判定する
  # workspace: 判定するワークスペースのWorkSpaceオブジェクト
  # number: 判定する演習の番号
  def look_unassigned_works(workspace, number)
    unassined_works = workspace.find_unassigned_works_in(number)
    finish_until(unassined_works.size == 0, "#{unassined_works.join(', ')} is not assigned.")
  end

  def help
    puts '*COMMAND FORMAT*'
    puts 'wgd check (-workroot [dir_name]) (-exercise [exe_number])'
    puts '-- "check" command will show working progression.'
  end

  def args_num
    0
  end

  def self.name
    'check'
  end

  def self.default_args
    {'-workroot' => Dir::pwd, '-exercise' => nil}
  end
end

# コマンドの判定やオプションハッシュの作成をするクラス
class CommandManager

  # コマンドの配列
  def self.commands
    [InitCommand, CreateCommand, CheckCommand, UndefinedCommand]
  end

  # 名前からコマンドを生成する
  # return: コマンドクラス
  def self.generate_command(name)
    command = commands.find{|cmd|  cmd.name == name}
    command = UndefinedCommand if command == nil
    command
  end

  # コマンドライン引数の配列からオプションのハッシュを生成する
  # ["-a", "b", "-c", "d"] => {"-a" => "b", "-c" => "d"}
  # args: コマンド名を除いたコマンドライン引数
  # return: 生成したオプションハッシュ
  def self.generate_option_hash(args)
    option_hash = {}
    while args.size > 0
      curr_arg = args[0]
      if option_format?(curr_arg)
        next_arg = args[1]
        option_hash[curr_arg] = next_arg
        args = args.drop(2)
      elsif option_flag_format?(curr_arg)
        option_hash[curr_arg] = true
        args = args.drop(1)
      else
        puts "\"#{curr_arg}\" is not a option."
        args = args.drop(1)
      end
    end
    option_hash
  end

  # 値付きのオプション"-hoge"かどうかを判定する
  # name: 判定する名前
  # return: 判定結果
  def self.option_format?(name)
    name.size >= 2 && name[0] == '-' && name[1] != '-'
  end

  # フラグオプション"--hoge"かどうかを判定する
  # name: 判定する名前
  # return: 判定結果
  def self.option_flag_format?(name)
    name.size >= 3 && name[0] == '-' && name[1] == '-'
  end
end

# メイン関数を持つクラス
class Main
  # メイン関数(Rubyでは本当は不要)
  def self.main
    command_c = CommandManager::generate_command(ARGV[0])
    command_args = ARGV.drop(1)
    option = command_c.default_args.update(CommandManager::generate_option_hash(command_args))
    command = command_c.new
    begin
      command.run(option)
    rescue
      command.help
    end
  end
end

# メイン関数呼び出し
Main.main
