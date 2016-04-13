# require_relativeについてはapp.rbのコメントを参照
require_relative './workspace'

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
