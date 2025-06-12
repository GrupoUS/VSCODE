#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Test Automation Suite
Executa testes automatizados nos scripts de automação/orquestração Python do projeto.
"""
import subprocess
import sys
from pathlib import Path

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

SCRIPTS_DIR = Path(__file__).parent

TESTS = [
    # manage-system
    ("manage-system.py", ["-a", "status"], "System status"),
    ("manage-system.py", ["-a", "stats"], "System stats"),
    # manage-logs
    ("manage-logs.py", ["-a", "list"], "List logs"),
    ("manage-logs.py", ["-a", "clear"], "Clear logs"),
    # manage-backups
    ("manage-backups.py", ["-a", "list"], "List backups"),
    # manage-tasks
    ("manage-tasks.py", ["-a", "list"], "List tasks"),
    # manage-refiners
    ("manage-refiners.py", ["-a", "list"], "List refiners"),
    # manage-agents
    ("manage-agents.py", ["-a", "list"], "List agents"),
    # manage-knowledge-graph
    ("manage-knowledge-graph.py", ["-a", "list-nodes"], "List knowledge graph nodes"),
    # invoke-workflow
    ("invoke-workflow.py", ["-a", "list"], "List workflows"),
]

def run_test(script, args, description):
    script_path = SCRIPTS_DIR / script
    if not script_path.exists():
        return False, f"Script não encontrado: {script_path}"
    try:
        result = subprocess.run([sys.executable, str(script_path)] + args, capture_output=True, text=True, timeout=20)
        success = result.returncode == 0
        output = result.stdout.strip() + ("\n" + result.stderr.strip() if result.stderr.strip() else "")
        return success, output
    except Exception as e:
        return False, str(e)

def main():
    table = Table(title="Resultados dos Testes de Automação", show_lines=True)
    table.add_column("Script", style="cyan")
    table.add_column("Descrição")
    table.add_column("Resultado")
    table.add_column("Saída (resumida)")
    total, passed = 0, 0
    for script, args, desc in TESTS:
        total += 1
        success, output = run_test(script, args, desc)
        if success:
            passed += 1
        table.add_row(script, desc, "[green]OK[/green]" if success else "[red]ERRO[/red]", output[:120].replace('\n',' '))
    console.print(table)
    print(f"\n[bold]Total:[/bold] {total}  [green]Passaram:[/green] {passed}  [red]Falharam:[/red] {total-passed}")
    if passed < total:
        sys.exit(1)

if __name__ == "__main__":
    main()
