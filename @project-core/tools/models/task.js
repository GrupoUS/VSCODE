class Task {
  constructor(id, title, description, status = 'pending', priority = 'medium', dependencies = []) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.status = status;
    this.priority = priority;
    this.dependencies = dependencies;
  }
}

module.exports = Task;
