#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Task Manager (Python)
Este script substitui o antigo manage-tasks.ps1, conforme diretriz de migração para Python.
"""
import argparse
import json
import sys
from pathlib import Path
from datetime import datetime

try:
    from rich import print
    from rich.console import Console
    from rich.table import Table
except ImportError:
    print("[yellow]Rich não encontrado. Recomenda-se instalar com: pip install rich[/yellow]")
    def print(*args, **kwargs):
        __builtins__.print(*args, **kwargs)
    class Console:
        def print(self, *args, **kwargs):
            print(*args, **kwargs)
    class Table:
        pass
console = Console()

TASKS_PATH = Path(__file__).parent.parent / "tasks" / "tasks.json"

# Função para carregar tarefas
def load_tasks():
    if not TASKS_PATH.exists():
        console.print(f"[red]Tasks file not found: {TASKS_PATH}")
        sys.exit(1)
    with open(TASKS_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

def save_tasks(data):
    with open(TASKS_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def list_tasks(status=None):
    data = load_tasks()
    tasks = data.get('tasks', [])
    if status:
        tasks = [t for t in tasks if t.get('status') == status]
    if not tasks:
        print("[yellow]Nenhuma tarefa encontrada.[/yellow]")
        return
    table = Table(title="Tasks", show_lines=True)
    table.add_column("ID", style="cyan")
    table.add_column("Title")
    table.add_column("Status")
    table.add_column("Priority")
    table.add_column("Dependencies")
    for t in tasks:
        table.add_row(
            str(t.get('id','-')),
            t.get('title','-'),
            t.get('status','-'),
            t.get('priority','-'),
            ', '.join(str(dep) for dep in t.get('dependencies', []))
        )
    console.print(table)

def task_status(task_id):
    data = load_tasks()
    t = next((x for x in data.get('tasks', []) if str(x.get('id')) == str(task_id)), None)
    if not t:
        print(f"[red]Task '{task_id}' not found.[/red]")
        sys.exit(1)
    print(f"\n[bold]Task Status:[/bold] {t.get('id')}")
    print(f"  Title: {t.get('title','-')}")
    print(f"  Status: {t.get('status','-')}")
    print(f"  Priority: {t.get('priority','-')}")
    print(f"  Dependencies: {', '.join(str(dep) for dep in t.get('dependencies', []))}")
    print(f"  Description: {t.get('description','-')}")
    print(f"  Details: {t.get('details','-')}")
    print(f"  Test Strategy: {t.get('testStrategy','-')}")
    print(f"  Subtasks: {len(t.get('subtasks', []))}")

def add_task(title, description, priority="medium", dependencies=None):
    data = load_tasks()
    tasks = data.get('tasks', [])
    new_id = max([t.get('id',0) for t in tasks], default=0) + 1
    task = {
        'id': new_id,
        'title': title,
        'description': description,
        'status': 'pending',
        'priority': priority,
        'dependencies': dependencies or [],
        'details': '',
        'testStrategy': '',
        'subtasks': []
    }
    tasks.append(task)
    data['tasks'] = tasks
    save_tasks(data)
    print(f"[green]Task '{title}' added successfully with ID {new_id}.[/green]")

def update_task(task_id, **kwargs):
    data = load_tasks()
    tasks = data.get('tasks', [])
    t = next((x for x in tasks if str(x.get('id')) == str(task_id)), None)
    if not t:
        print(f"[red]Task '{task_id}' not found.[/red]")
        sys.exit(1)
    for k, v in kwargs.items():
        if v is not None:
            t[k] = v
    save_tasks(data)
    print(f"[green]Task '{task_id}' updated successfully.[/green]")

def remove_task(task_id):
    data = load_tasks()
    tasks = data.get('tasks', [])
    new_tasks = [t for t in tasks if str(t.get('id')) != str(task_id)]
    if len(new_tasks) == len(tasks):
        print(f"[red]Task '{task_id}' not found.[/red]")
        sys.exit(1)
    data['tasks'] = new_tasks
    save_tasks(data)
    print(f"[green]Task '{task_id}' removed successfully.[/green]")

def set_task_status(task_id, status):
    data = load_tasks()
    t = next((x for x in data.get('tasks', []) if str(x.get('id')) == str(task_id)), None)
    if not t:
        print(f"[red]Task '{task_id}' not found.[/red]")
        sys.exit(1)
    t['status'] = status
    save_tasks(data)
    print(f"[green]Task '{task_id}' status set to '{status}'.[/green]")

def validate_task(task_id):
    data = load_tasks()
    t = next((x for x in data.get('tasks', []) if str(x.get('id')) == str(task_id)), None)
    if not t:
        print(f"[red]Task '{task_id}' not found.[/red]")
        sys.exit(1)
    # Simulação de validação
    print(f"[bold]Validating task:[/bold] {t.get('id')}")
    print(f"  Title: {t.get('title','-')}")
    print(f"  Status: {t.get('status','-')}")
    print(f"  Test Strategy: {t.get('testStrategy','-')}")
    print("[green]Task validation completed (simulado).[/green]")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - Task Manager (Python)")
    parser.add_argument("-a", "--action", choices=["list", "status", "add", "update", "remove", "set-status", "validate"], required=True, help="Ação a executar")
    parser.add_argument("-i", "--id", help="ID da tarefa")
    parser.add_argument("-t", "--title", help="Título da tarefa")
    parser.add_argument("-d", "--description", help="Descrição da tarefa")
    parser.add_argument("-p", "--priority", help="Prioridade da tarefa")
    parser.add_argument("--dependencies", nargs='*', help="IDs das dependências")
    parser.add_argument("--status", help="Novo status da tarefa")
    parser.add_argument("--details", help="Detalhes da tarefa")
    parser.add_argument("--test-strategy", help="Estratégia de teste da tarefa")
    args = parser.parse_args()

    if args.action == "list":
        list_tasks()
    elif args.action == "status":
        if not args.id:
            print("[red]É necessário informar o ID da tarefa com -i[/red]")
            sys.exit(1)
        task_status(args.id)
    elif args.action == "add":
        if not args.title or not args.description:
            print("[red]É necessário informar o título e descrição da tarefa com -t e -d[/red]")
            sys.exit(1)
        add_task(args.title, args.description, priority=args.priority or "medium", dependencies=args.dependencies)
    elif args.action == "update":
        if not args.id:
            print("[red]É necessário informar o ID da tarefa com -i[/red]")
            sys.exit(1)
        update_task(args.id, title=args.title, description=args.description, priority=args.priority, dependencies=args.dependencies, details=args.details, testStrategy=args.test_strategy)
    elif args.action == "remove":
        if not args.id:
            print("[red]É necessário informar o ID da tarefa com -i[/red]")
            sys.exit(1)
        remove_task(args.id)
    elif args.action == "set-status":
        if not args.id or not args.status:
            print("[red]É necessário informar o ID da tarefa com -i e o status com --status[/red]")
            sys.exit(1)
        set_task_status(args.id, args.status)
    elif args.action == "validate":
        if not args.id:
            print("[red]É necessário informar o ID da tarefa com -i[/red]")
            sys.exit(1)
        validate_task(args.id)
