#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Log Manager (Python)
Este script substitui o antigo manage-logs.ps1, conforme diretriz de migração para Python.
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

LOGS_PATH = Path(__file__).parent.parent / "logs" / "system-logs.json"
EXPORT_PATH = Path(__file__).parent.parent / "logs" / "exported-logs.json"

# Função para carregar logs
def load_logs():
    if not LOGS_PATH.exists():
        console.print(f"[red]Logs file not found: {LOGS_PATH}")
        sys.exit(1)
    with open(LOGS_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

def save_logs(data):
    with open(LOGS_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def list_logs():
    data = load_logs()
    logs = data.get('logs', [])
    if not logs:
        print("[yellow]Nenhum log encontrado.[/yellow]")
        return
    table = Table(title="System Logs", show_lines=True)
    table.add_column("Timestamp", style="cyan")
    table.add_column("Level")
    table.add_column("Message")
    for log in logs:
        table.add_row(
            log.get('timestamp','-'),
            log.get('level','-'),
            log.get('message','-')
        )
    console.print(table)

def search_logs(keyword):
    data = load_logs()
    logs = data.get('logs', [])
    found = [log for log in logs if keyword.lower() in log.get('message','').lower()]
    if not found:
        print(f"[yellow]Nenhum log encontrado com a palavra-chave '{keyword}'.[/yellow]")
        return
    table = Table(title=f"Logs contendo '{keyword}'", show_lines=True)
    table.add_column("Timestamp", style="cyan")
    table.add_column("Level")
    table.add_column("Message")
    for log in found:
        table.add_row(
            log.get('timestamp','-'),
            log.get('level','-'),
            log.get('message','-')
        )
    console.print(table)

def clear_logs():
    save_logs({'logs': []})
    print("[green]Todos os logs foram limpos.[/green]")

def export_logs():
    data = load_logs()
    with open(EXPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    print(f"[green]Logs exportados para {EXPORT_PATH}[/green]")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - Log Manager (Python)")
    parser.add_argument("-a", "--action", choices=["list", "search", "clear", "export"], required=True, help="Ação a executar")
    parser.add_argument("-k", "--keyword", help="Palavra-chave para busca nos logs")
    args = parser.parse_args()

    if args.action == "list":
        list_logs()
    elif args.action == "search":
        if not args.keyword:
            print("[red]É necessário informar a palavra-chave com -k ou --keyword[/red]")
            sys.exit(1)
        search_logs(args.keyword)
    elif args.action == "clear":
        clear_logs()
    elif args.action == "export":
        export_logs()
