#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Backup Manager (Python)
Este script substitui o antigo manage-backups.ps1, conforme diretriz de migração para Python.
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

BACKUP_PATH = Path(__file__).parent.parent / "backups"
MCP_CONFIG_PATH = Path(__file__).parent.parent / "configs" / "mcp-master-unified.json"

# Função para criar backup
def create_backup():
    BACKUP_PATH.mkdir(exist_ok=True)
    backup_file = BACKUP_PATH / f"system-backup-{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    if not MCP_CONFIG_PATH.exists():
        print(f"[red]MCP configuration file not found: {MCP_CONFIG_PATH}")
        sys.exit(1)
    with open(MCP_CONFIG_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    with open(backup_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    print(f"[green]Backup criado em {backup_file}[/green]")

def list_backups():
    if not BACKUP_PATH.exists():
        print("[yellow]Nenhum backup encontrado.[/yellow]")
        return
    backups = sorted(BACKUP_PATH.glob('system-backup-*.json'))
    if not backups:
        print("[yellow]Nenhum backup encontrado.[/yellow]")
        return
    table = Table(title="Backups", show_lines=True)
    table.add_column("Arquivo", style="cyan")
    table.add_column("Data/Hora")
    for b in backups:
        dt = b.stem.replace('system-backup-','')
        try:
            dt_fmt = datetime.strptime(dt, '%Y%m%d_%H%M%S').strftime('%d/%m/%Y %H:%M:%S')
        except Exception:
            dt_fmt = '-'
        table.add_row(str(b.name), dt_fmt)
    console.print(table)

def restore_backup(backup_file):
    backup_path = BACKUP_PATH / backup_file
    if not backup_path.exists():
        print(f"[red]Backup não encontrado: {backup_path}")
        sys.exit(1)
    with open(backup_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    with open(MCP_CONFIG_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    print(f"[green]Sistema restaurado a partir de {backup_path}[/green]")

def remove_backup(backup_file):
    backup_path = BACKUP_PATH / backup_file
    if not backup_path.exists():
        print(f"[red]Backup não encontrado: {backup_path}")
        sys.exit(1)
    backup_path.unlink()
    print(f"[green]Backup removido: {backup_path}[/green]")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - Backup Manager (Python)")
    parser.add_argument("-a", "--action", choices=["create", "list", "restore", "remove"], required=True, help="Ação a executar")
    parser.add_argument("-f", "--file", help="Nome do arquivo de backup para restaurar ou remover")
    args = parser.parse_args()

    if args.action == "create":
        create_backup()
    elif args.action == "list":
        list_backups()
    elif args.action == "restore":
        if not args.file:
            print("[red]É necessário informar o nome do arquivo de backup com -f ou --file[/red]")
            sys.exit(1)
        restore_backup(args.file)
    elif args.action == "remove":
        if not args.file:
            print("[red]É necessário informar o nome do arquivo de backup com -f ou --file[/red]")
            sys.exit(1)
        remove_backup(args.file)
