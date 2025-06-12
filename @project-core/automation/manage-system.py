#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - System Manager (Python)
Este script substitui o antigo manage-system.ps1, conforme diretriz de migração para Python.
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

MCP_CONFIG_PATH = Path(__file__).parent.parent / "configs" / "mcp-master-unified.json"
BACKUP_PATH = Path(__file__).parent.parent / "backups"

# Função para carregar configuração MCP
def load_mcp_config():
    if not MCP_CONFIG_PATH.exists():
        console.print(f"[red]MCP configuration file not found: {MCP_CONFIG_PATH}")
        sys.exit(1)
    with open(MCP_CONFIG_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

def save_mcp_config(data):
    with open(MCP_CONFIG_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def system_status():
    config = load_mcp_config()
    print("[bold]System Status:[/bold]")
    print(f"  MCP Servers: {len(config.get('mcpServers', {}))}")
    print(f"  Last Updated: {config.get('lastUpdated', '-')}")
    print(f"  Version: {config.get('version', '-')}")

def system_start():
    print("[green]System started (simulado).[/green]")

def system_stop():
    print("[yellow]System stopped (simulado).[/yellow]")

def system_restart():
    print("[yellow]Restarting system...")
    system_stop()
    system_start()
    print("[green]System restarted (simulado).[/green]")

def system_optimize():
    print("[blue]System optimization completed (simulado).[/blue]")

def system_backup():
    BACKUP_PATH.mkdir(exist_ok=True)
    backup_file = BACKUP_PATH / f"system-backup-{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    config = load_mcp_config()
    with open(backup_file, 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=2)
    print(f"[green]Backup created at {backup_file}[/green]")

def system_restore(restore_path):
    restore_file = Path(restore_path)
    if not restore_file.exists():
        print(f"[red]Restore file not found: {restore_file}")
        sys.exit(1)
    with open(restore_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    save_mcp_config(data)
    print(f"[green]System restored from {restore_file}[/green]")

def system_stats():
    config = load_mcp_config()
    print("[bold]System Stats:[/bold]")
    print(f"  MCP Servers: {len(config.get('mcpServers', {}))}")
    print(f"  Version: {config.get('version', '-')}")
    print(f"  Last Updated: {config.get('lastUpdated', '-')}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - System Manager (Python)")
    parser.add_argument("-a", "--action", choices=["status", "start", "stop", "restart", "optimize", "backup", "restore", "stats"], required=True, help="Ação a executar")
    parser.add_argument("-r", "--restore-path", help="Caminho do arquivo de backup para restaurar")
    args = parser.parse_args()

    if args.action == "status":
        system_status()
    elif args.action == "start":
        system_start()
    elif args.action == "stop":
        system_stop()
    elif args.action == "restart":
        system_restart()
    elif args.action == "optimize":
        system_optimize()
    elif args.action == "backup":
        system_backup()
    elif args.action == "restore":
        if not args.restore_path:
            print("[red]É necessário informar o caminho do backup com -r ou --restore-path[/red]")
            sys.exit(1)
        system_restore(args.restore_path)
    elif args.action == "stats":
        system_stats()
