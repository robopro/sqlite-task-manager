require "sqlite3"
require 'byebug'
require_relative "../task"

db_file_path = File.join(File.dirname(__FILE__), "tasks_spec.db")
DB = SQLite3::Database.new(db_file_path)
DB.results_as_hash = true

describe Task do

  before(:each) do
    DB.execute('DROP TABLE IF EXISTS tasks;')
    create_statement = "CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, done INTEGER DEFAULT (0));"
    DB.execute(create_statement)
  end

  describe "self.find" do
    it "should return an object of the Task class" do
      DB.execute("INSERT INTO tasks (title) VALUES ('Test Title');")
      expect(Task.find(1)).to be_a Task
    end
  end

  describe "save" do
    it "should *insert* the task if it has just been instantiated" do
      task = Task.new(title: "Test Title Save")
      task.save
      task = Task.find(1)
      expect(task).not_to be_nil
    end

    it "should set the @id when inserting for the first time" do
      task = Task.new()
      task.save
      expect(task.id).to eq(1)
    end

    it "should *update* the post if it already exists in the DB" do
      DB.execute("INSERT INTO tasks (title) VALUES ('Test Title Update')")
      task = Task.find(1)
      task.title = "Updated Test Title"
      task.save
      updated_task = Task.find(1)
      expect(updated_task.title).to eq("Updated Test Title")
    end
  end

  describe "self.all" do
    it "should return all records from the tasks table" do
      first_task = Task.new(title: "first")
      first_task.save
      second_task = Task.new(title: "second")
      second_task.save
      all_tasks = Task.all
      expect(all_tasks).to be_a Array
      expect(all_tasks.length).to eq(2)
      expect(all_tasks.first.id).to eq(1)
      expect(all_tasks.last.id).to eq(2)
    end
  end

  # describe "destroy" do
  #   it "should remove record from database" do
  #     task = Task.new(title: "first")
  #     task.save
  #     id = task.id
  #     task.destroy
  #     expect(Task.find(id)).to eq(nil)
  #   end
  # end
end
