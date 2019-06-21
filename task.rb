class Task
  attr_reader :id
  attr_accessor :title, :description

  def initialize(**attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @description = attributes[:description]
  end

  def self.find(id)
    result = DB.execute("SELECT * FROM tasks WHERE id = ?", id).first
    result.transform_keys! { |key| key.to_sym }
    Task.new(result)
    # Task.new(id: result["id"], title: result["title"], description: result["description"])
  end

  def save
    if @id.nil?
      DB.execute("INSERT INTO tasks (title, description) VALUES (?, ?)", @title, @description)
      @id = DB.last_insert_row_id
    else
      DB.execute("UPDATE tasks SET title = ?, description = ?", @title, @description)
    end
  end

  def self.all
    results = DB.execute("SELECT * FROM tasks")
    results.map do |result|
      result.transform_keys! { |key| key.to_sym }
      Task.new(result)
    end
  end
end
