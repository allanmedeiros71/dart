import 'dart:async';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
}

class TaskManager {
  final List<Task> _listTasks = []; // Perceba que "Task" ainda não existe.
  final StreamController<String> _tasksController = StreamController<String>();

  Stream<String> get stream => _tasksController.stream;

  addTask(Task task) {
    _listTasks.add(task);
    _tasksController.add("Nova tarefa ${task.title} adicionada.");
  }

  toggleTaskStatus(String id) {
    int index = _listTasks.indexWhere((task) => task.id == id);
    Task task = _listTasks[index];
    task.isCompleted = !task.isCompleted;
    _listTasks[index] = task;

    if (task.isCompleted) {
      _tasksController.add("${task.title} foi concluída.");
    } else {
      _tasksController.add("${task.title} ainda não concluída.");
    }
  }

  List<Task> getAll() {
    _tasksController.add("Visualização de todas as tarefas foi solicitada.");
    return _listTasks;
  }

  Task getById(String id) {
    _tasksController.add("Tarefa encontrada.");
    return _listTasks.firstWhere((task) => task.id == id);
  }

  delete(String id) {
    _listTasks.removeWhere((task) => task.id == id);
    _tasksController.add("Tarefa removida.");
  }
}

void main() {
  TaskManager taskManager = TaskManager();
  StreamSubscription _ = taskManager.stream.listen((message) {
    print("Notificação: $message");
  });

  // Adiciona as tarefas
  taskManager.addTask(
    Task(
      id: '1',
      title: 'Estudar Dart',
      description: 'Completar o módulo de fundamentos de Dart',
      isCompleted: false,
    ),
  );
  taskManager.addTask(
    Task(
      id: '2',
      title: 'Fazer compras',
      description: 'Comprar frutas e legumes no mercado',
      isCompleted: false,
    ),
  );
  taskManager.addTask(
    Task(
      id: '3',
      title: 'Ir à academia',
      description: 'Treino de musculação às 18h',
      isCompleted: false,
    ),
  );

  // Visualiza todas as tarefas
  List<Task> allTasks = taskManager.getAll();
  print('--- Todas as Tarefas ---');
  for (Task task in allTasks) {
    print(
      'ID: ${task.id}, Título: ${task.title}, Concluída: ${task.isCompleted}',
    );
  }

  // Marca a tarefa 1 como concluída
  taskManager.toggleTaskStatus('1');

  // Visualiza a tarefa por ID
  Task taskById = taskManager.getById('1');
  print('--- Tarefa Buscada por ID ---');
  print(
    'ID: ${taskById.id}, Título: ${taskById.title}, Concluída: ${taskById.isCompleted}',
  );

  // Remove uma tarefa
  taskManager.delete('2');

  // Visualiza todas as tarefas após remoção
  allTasks = taskManager.getAll();
  print('--- Tarefas Após Remoção ---');
  for (Task task in allTasks) {
    print(
      'ID: ${task.id}, Título: ${task.title}, Concluída: ${task.isCompleted}',
    );
  }
}
