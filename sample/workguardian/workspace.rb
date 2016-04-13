require 'json'

class WorkSpace
  attr_reader :work_root

  def initialize(work_root)
    @work_root = work_root
    @conf = load_configuration(work_root)
  end

  def load_configuration(work_root)
    raise 'Configuration file has not found.' unless WorkSpace.configuration_file?(work_root)
    json = open(work_root + '/workguardian.json')
    begin
      JSON.load(json)
    rescue
      raise 'Configuration file loading has failured.'
    ensure
      json.close
    end
  end

  def exercises
    @conf['exercises']
  end

  def exercise_names
    exercises.map{|exe| exe['name']}
  end

  def generate_exercise(exercise_hash)
    name = exercise_hash['name']
    assignments = exercise_hash['assignments']
    Exercise.new(name, @work_root, assignments)
  end

  def find_unassigned_works_in(exercise_number)
    raise "Exercise number required from 0 to #{exercises.size - 1}" if exercises.size - 1 < exercise_number || exercise_number < 0
    exercise = generate_exercise(exercises[exercise_number])
    exercise.find_unassigned_works
  end

  def directory_structure?
    entries = Dir::entries(@work_root)
    exercise_names.all?{|exe| entries.any?{|entry| entry == exe}}
  end

  def find_unexisted_exercises
    entries = Dir::entries(@work_root)
    exercise_names.select{|exe| !entries.any?{|entry| entry == exe}}
  end

  def create_directory_structure
    for exercise in find_unexisted_exercises
      Dir::mkdir(@work_root + '/' + exercise)
    end
  end

  def self.configuration_file?(work_root)
    Dir::entries(work_root).any?{|element| element == 'workguardian.json'}
  end
end

class Exercise
  def initialize(name, work_root, assignments)
    @name = name
    @exe_root = work_root + '/' + name
    @assignments = assignments
  end

  def find_assigned_works
    @assignments.select{|assignment| Dir::entries(@exe_root).any?{|elem| elem == assignment} }
  end

  def find_unassigned_works
    @assignments.select{|assignment| !Dir::entries(@exe_root).any?{|elem| elem == assignment} }
  end
end
