#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Refiner Manager (Python)
Este script substitui o antigo manage-refiners.ps1, conforme diretriz de migração para Python.
"""
import argparse
import json
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

MCP_CONFIG_PATH = Path(__file__).parent.parent / "configs" / "mcp-master-unified.json"

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

def list_refiners():
    config = load_mcp_config()
    refiners = [v for v in config.get('mcpServers', {}).values() if v.get('type') in ("refiner", "refinement")]
    if not refiners:
        print("[yellow]Nenhum refiner encontrado.[/yellow]")
        return
    table = Table(title="Available Refiners", show_lines=True)
    table.add_column("Name", style="cyan")
    table.add_column("Type")
    table.add_column("Status")
    table.add_column("Capabilities")
    for ref in refiners:
        status = "enabled" if ref.get('enabled', True) else "disabled"
        table.add_row(
            ref.get('name', '-'),
            ref.get('type', '-'),
            status,
            ', '.join(ref.get('capabilities', []))
        )
    console.print(table)

def refiner_status(refiner_name):
    config = load_mcp_config()
    ref = next((v for v in config.get('mcpServers', {}).values() if v.get('name') == refiner_name), None)
    if not ref:
        print(f"[red]Refiner '{refiner_name}' not found.[/red]")
        sys.exit(1)
    status = "enabled" if ref.get('enabled', True) else "disabled"
    print(f"\n[bold]Refiner Status:[/bold] {ref.get('name')}")
    print(f"  Type: {ref.get('type','-')}")
    print(f"  Status: {status}")
    print(f"  Priority: {ref.get('priority','-')}")
    print(f"  Capabilities: {', '.join(ref.get('capabilities',[]))}")
    print(f"  Environments: {', '.join(ref.get('environments',[]))}")
    cr = ref.get('complexityRange')
    if cr:
        print(f"  Complexity Range: {cr[0]}-{cr[1]}")

def set_refiner_status(refiner_name, enable=True):
    config = load_mcp_config()
    found = False
    for v in config.get('mcpServers', {}).values():
        if v.get('name') == refiner_name:
            v['enabled'] = enable
            found = True
            break
    if not found:
        print(f"[red]Refiner '{refiner_name}' not found.[/red]")
        sys.exit(1)
    save_mcp_config(config)
    print(f"[green]Refiner '{refiner_name}' {'enabled' if enable else 'disabled'} successfully.[/green]")

def restart_refiner(refiner_name):
    set_refiner_status(refiner_name, enable=False)
    print("[yellow]Aguardando 2 segundos para reiniciar...[/yellow]")
    import time; time.sleep(2)
    set_refiner_status(refiner_name, enable=True)
    print(f"[green]Refiner '{refiner_name}' restarted successfully.[/green]")

def configure_refiner(refiner_name, config_path):
    if not Path(config_path).exists():
        print(f"[red]Configuration file not found: {config_path}")
        sys.exit(1)
    config = load_mcp_config()
    ref = next((v for v in config.get('mcpServers', {}).values() if v.get('name') == refiner_name), None)
    if not ref:
        print(f"[red]Refiner '{refiner_name}' not found.[/red]")
        sys.exit(1)
    with open(config_path, 'r', encoding='utf-8') as f:
        ref_config = json.load(f)
    ref['config'] = ref_config
    save_mcp_config(config)
    print(f"[green]Refiner '{refiner_name}' configured successfully.[/green]")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - Refiner Manager (Python)")
    parser.add_argument("-a", "--action", choices=["list", "status", "start", "stop", "restart", "configure"], required=True, help="Ação a executar")
    parser.add_argument("-n", "--name", help="Nome do refiner")
    parser.add_argument("-c", "--config", help="Caminho do arquivo de configuração para o refiner")
    args = parser.parse_args()

    if args.action == "list":
        list_refiners()
    elif args.action == "status":
        if not args.name:
            print("[red]É necessário informar o nome do refiner com -n ou --name[/red]")
            sys.exit(1)
        refiner_status(args.name)
    elif args.action == "start":
        if not args.name:
            print("[red]É necessário informar o nome do refiner com -n ou --name[/red]")
            sys.exit(1)
        set_refiner_status(args.name, enable=True)
    elif args.action == "stop":
        if not args.name:
            print("[red]É necessário informar o nome do refiner com -n ou --name[/red]")
            sys.exit(1)
        set_refiner_status(args.name, enable=False)
    elif args.action == "restart":
        if not args.name:
            print("[red]É necessário informar o nome do refiner com -n ou --name[/red]")
            sys.exit(1)
        restart_refiner(args.name)
    elif args.action == "configure":
        if not args.name or not args.config:
            print("[red]É necessário informar o nome do refiner com -n e o caminho do config com -c[/red]")
            sys.exit(1)
        configure_refiner(args.name, args.config)
