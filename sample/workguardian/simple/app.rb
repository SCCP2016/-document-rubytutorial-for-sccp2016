# WorkGuardian
# 各演習(課題)用のディレクトリを自動生成して、課題の作成を監視します。

# require_relativeは実行ファイルのあるディレクトリ(この場合はapp.rbがあるディレクトリ)
# からの相対パスで指定したライブラリを読み込むメソッド。
# requireは実行した時のカレントディレクトリからの相対パスになってしまうので注意。
require_relative 'command'

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
