class Task {
    constructor(id, title, description, status = 'pending', dependencies = []) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.status = status;
        this.dependencies = dependencies;
    }
}

module.exports = Task;
