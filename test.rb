require "sqlite3"
DB = SQLite3::Database.new("tasks.db")
DB.results_as_hash = true
require_relative "task"

# Let's build a Task class capable of CRUD against a SQL table tasks.

# You are given a tasks.db database with one task (id = 1), a task.rb file to complete and a
# test.rb to test your code.

#   Implement the READ logic to find a given task (by its id)
#   Implement the CREATE logic in a save instance method
#   Implement the UPDATE logic in the same method
#   Implement the READ logic to retrieve all tasks (what type of method is it?)
#   Implement the DESTROY logic on a task

# TODO: CRUD some tasks

Task.new(title: "Morten", description: "Nice").save
p DB.execute("SELECT * FROM tasks")
