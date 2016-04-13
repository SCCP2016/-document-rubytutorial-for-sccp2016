require_relative 'abstract_method'
require_relative 'workspace'

include AbstractMethod

class Command
  absdef :run, :help, :args_num
  absdef_singleton :name, :default_args

  def raise_if_errored_args(args)
    raise "Required #{args_num} args, but #{args.size}." if !args?(args)
  end

  def args?(args)
    args.size >= args_num
  end
end

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

class InitCommand < Command
  def run(args)
    raise_if_errored_args(args)
    work_root = args['-workroot']

    if WorkSpace.configuration_file?(work_root)
      # Through proccesses if configuration file exists on the workspace root.
      puts "This workspace has initialized."
    else
      copy_conf_file(work_root)
      puts 'Initialize succeed.'
    end
  end
  
  # Create a configuration file and copy from the default configuration.
  def copy_conf_file(work_root)
    default = open(__dir__ + '/default.json', 'r')
    work_conf = open(work_root + '/workguardian.json', 'w+')
    work_conf.write(default.read)
    default.close
    work_conf.close
  end

  def help
    puts '*COMMAND FORMAT*'
    puts 'wgd init'
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
    puts 'wgd create'
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

  def finish_until(cond, message)
   raise message unless cond
  end

  def look_configure_file(work_root)
    finish_until(WorkSpace.configuration_file?(work_root),"Configuration file has not found.")
  end

  def look_directory_structure(workspace)
    finish_until(workspace.directory_structure?, "This workspace has not created directory structure.")
  end

  def look_unassigned_works(workspace, number)
    unassined_works = workspace.find_unassigned_works_in(number)
    finish_until(unassined_works.size == 0, "#{unassined_works.join(', ')} is not assigned.")
  end

  def help
    puts '*COMMAND FORMAT*'
    puts 'wgd check'
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

module CommandManager
  def self.commands
    [InitCommand, CreateCommand, CheckCommand, UndefinedCommand]
  end

  def self.generate_command(name)
    command = CommandManager::commands.find{|cmd|  cmd.name == name}
    command = UndefinedCommand unless command
    [command.new, command.default_args]
  end

  def self.generate_option_hash(cmd_args)
    def self.make_option_hash(option_hash, args)
      return option_hash if args.size <= 0
      curr_arg = args[0]
      if option_format?(curr_arg)
        next_arg = args[1]
        option_hash[curr_arg] = next_arg
        make_option_hash(option_hash, args.drop(2))
      elsif option_flag_format?(curr_arg)
        option_hash[curr_arg] = true
        make_option_hash(option_hash, args.drop(1))
      else
        puts "\"#{curr_arg}\" is not a option."
        make_option_hash(option_hash, args.drop(1))
      end
    end

    make_option_hash({}, cmd_args)
  end

  def self.option_format?(name)
    name.size >= 2 && name[0] == '-' && name[1] != '-'
  end

  def self.option_flag_format?(name)
    name.size >= 3 && name[0] == '-' && name[1] == '-'
  end
end
