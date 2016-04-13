require_relative 'command'

class Main
  def self.main
    command, default_args = CommandManager::generate_command(ARGV[0])
    command_args = ARGV.drop(1)
    option = default_args.update(CommandManager::generate_option_hash(command_args))
    begin
      command.run(option)
    rescue
      p $!
      command.help
    end
  end
end

Main.main
