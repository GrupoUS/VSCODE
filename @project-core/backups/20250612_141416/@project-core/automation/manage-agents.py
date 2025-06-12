#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Agent Manager (Python)
Este script substitui o antigo manage-agents.ps1, conforme diretriz de migração para Python.
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

def list_agents():
    config = load_mcp_config()
    agents = [v for v in config.get('mcpServers', {}).values() if v.get('type') == "agent"]
    if not agents:
        print("[yellow]Nenhum agente encontrado.[/yellow]")
        return
    table = Table(title="Available Agents", show_lines=True)
    table.add_column("Name", style="cyan")
    table.add_column("Role")
    table.add_column("Status")
    table.add_column("Capabilities")
    for ag in agents:
        status = "enabled" if ag.get('enabled', True) else "disabled"
        table.add_row(
            ag.get('name', '-'),
            ag.get('role', '-'),
            status,
            ', '.join(ag.get('capabilities', []))
        )
    console.print(table)

def agent_status(agent_name):
    config = load_mcp_config()
    ag = next((v for v in config.get('mcpServers', {}).values() if v.get('name') == agent_name), None)
    if not ag:
        print(f"[red]Agent '{agent_name}' not found.[/red]")
        sys.exit(1)
    status = "enabled" if ag.get('enabled', True) else "disabled"
    print(f"\n[bold]Agent Status:[/bold] {ag.get('name')}")
    print(f"  Role: {ag.get('role','-')}")
    print(f"  Status: {status}")
    print(f"  Priority: {ag.get('priority','-')}")
    print(f"  Capabilities: {', '.join(ag.get('capabilities',[]))}")
    print(f"  Environments: {', '.join(ag.get('environments',[]))}")
    cr = ag.get('complexityRange')
    if cr:
        print(f"  Complexity Range: {cr[0]}-{cr[1]}")

def set_agent_status(agent_name, enable=True):
    config = load_mcp_config()
    found = False
    for v in config.get('mcpServers', {}).values():
        if v.get('name') == agent_name:
            v['enabled'] = enable
            found = True
            break
    if not found:
        print(f"[red]Agent '{agent_name}' not found.[/red]")
        sys.exit(1)
    save_mcp_config(config)
    print(f"[green]Agent '{agent_name}' {'enabled' if enable else 'disabled'} successfully.[/green]")

def restart_agent(agent_name):
    set_agent_status(agent_name, enable=False)
    print("[yellow]Aguardando 2 segundos para reiniciar...[/yellow]")
    import time; time.sleep(2)
    set_agent_status(agent_name, enable=True)
    print(f"[green]Agent '{agent_name}' restarted successfully.[/green]")

def configure_agent(agent_name, config_path):
    if not Path(config_path).exists():
        print(f"[red]Configuration file not found: {config_path}")
        sys.exit(1)
    config = load_mcp_config()
    ag = next((v for v in config.get('mcpServers', {}).values() if v.get('name') == agent_name), None)
    if not ag:
        print(f"[red]Agent '{agent_name}' not found.[/red]")
        sys.exit(1)
    with open(config_path, 'r', encoding='utf-8') as f:
        ag_config = json.load(f)
    ag['config'] = ag_config
    save_mcp_config(config)
    print(f"[green]Agent '{agent_name}' configured successfully.[/green]")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - Agent Manager (Python)")
    parser.add_argument("-a", "--action", choices=["list", "status", "start", "stop", "restart", "configure"], required=True, help="Ação a executar")
    parser.add_argument("-n", "--name", help="Nome do agente")
    parser.add_argument("-c", "--config", help="Caminho do arquivo de configuração para o agente")
    args = parser.parse_args()

    if args.action == "list":
        list_agents()
    elif args.action == "status":
        if not args.name:
            print("[red]É necessário informar o nome do agente com -n ou --name[/red]")
            sys.exit(1)
        agent_status(args.name)
    elif args.action == "start":
        if not args.name:
            print("[red]É necessário informar o nome do agente com -n ou --name[/red]")
            sys.exit(1)
        set_agent_status(args.name, enable=True)
    elif args.action == "stop":
        if not args.name:
            print("[red]É necessário informar o nome do agente com -n ou --name[/red]")
            sys.exit(1)
        set_agent_status(args.name, enable=False)
    elif args.action == "restart":
        if not args.name:
            print("[red]É necessário informar o nome do agente com -n ou --name[/red]")
            sys.exit(1)
        restart_agent(args.name)
    elif args.action == "configure":
        if not args.name or not args.config:
            print("[red]É necessário informar o nome do agente com -n e o caminho do config com -c[/red]")
            sys.exit(1)
        configure_agent(args.name, args.config)
