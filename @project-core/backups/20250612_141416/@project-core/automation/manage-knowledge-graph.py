#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.5 - Knowledge Graph Manager (Python)
Este script substitui o antigo manage-knowledge-graph.ps1, conforme diretriz de migração para Python.
"""
import argparse
import json
import os
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

KNOWLEDGE_GRAPH_PATH = Path(__file__).parent.parent / "knowledge" / "knowledge_graph.json"

# Função para carregar o grafo de conhecimento
def load_knowledge_graph():
    if not KNOWLEDGE_GRAPH_PATH.exists():
        console.print(f"[red]Knowledge graph file not found at {KNOWLEDGE_GRAPH_PATH}[/red]")
        sys.exit(1)
    with open(KNOWLEDGE_GRAPH_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

# Função para salvar o grafo de conhecimento
def save_knowledge_graph(data):
    with open(KNOWLEDGE_GRAPH_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

# Função para listar nós
def list_nodes():
    data = load_knowledge_graph()
    nodes = data.get('nodes', [])
    if not nodes:
        print("[yellow]Nenhum nó encontrado.[/yellow]")
        return
    table = Table(title="Knowledge Graph Nodes", show_lines=True)
    table.add_column("ID", style="cyan")
    table.add_column("Type")
    table.add_column("Properties")
    for node in nodes:
        props = ', '.join([f"{k}: {v}" for k, v in node.get('properties', {}).items()])
        table.add_row(
            node.get('id', '-'),
            node.get('type', '-'),
            props
        )
    console.print(table)

# Função para listar conexões
def list_connections():
    data = load_knowledge_graph()
    connections = data.get('connections', [])
    if not connections:
        print("[yellow]Nenhuma conexão encontrada.[/yellow]")
        return
    table = Table(title="Knowledge Graph Connections", show_lines=True)
    table.add_column("Source", style="cyan")
    table.add_column("Target", style="cyan")
    table.add_column("Type")
    table.add_column("Properties")
    for conn in connections:
        props = ', '.join([f"{k}: {v}" for k, v in conn.get('properties', {}).items()])
        table.add_row(
            conn.get('source', '-'),
            conn.get('target', '-'),
            conn.get('type', '-'),
            props
        )
    console.print(table)

# Função para adicionar nó
def add_node(node_id, node_type, properties=None):
    data = load_knowledge_graph()
    nodes = data.get('nodes', [])
    if any(node.get('id') == node_id for node in nodes):
        print(f"[red]Node '{node_id}' already exists.[/red]")
        sys.exit(1)
    new_node = {
        'id': node_id,
        'type': node_type,
        'properties': properties or {}
    }
    nodes.append(new_node)
    data['nodes'] = nodes
    save_knowledge_graph(data)
    print(f"[green]Node '{node_id}' added successfully.[/green]")

# Função para adicionar conexão
def add_connection(source, target, conn_type, properties=None):
    data = load_knowledge_graph()
    connections = data.get('connections', [])
    if any(conn.get('source') == source and conn.get('target') == target for conn in connections):
        print(f"[red]Connection '{source} -> {target}' already exists.[/red]")
        sys.exit(1)
    new_conn = {
        'source': source,
        'target': target,
        'type': conn_type,
        'properties': properties or {}
    }
    connections.append(new_conn)
    data['connections'] = connections
    save_knowledge_graph(data)
    print(f"[green]Connection '{source} -> {target}' added successfully.[/green]")

# Função para remover nó
def remove_node(node_id):
    data = load_knowledge_graph()
    nodes = data.get('nodes', [])
    if not any(node.get('id') == node_id for node in nodes):
        print(f"[red]Node '{node_id}' not found.[/red]")
        sys.exit(1)
    data['nodes'] = [node for node in nodes if node.get('id') != node_id]
    connections = data.get('connections', [])
    data['connections'] = [conn for conn in connections if conn.get('source') != node_id and conn.get('target') != node_id]
    save_knowledge_graph(data)
    print(f"[green]Node '{node_id}' removed successfully.[/green]")

# Função para remover conexão
def remove_connection(source, target):
    data = load_knowledge_graph()
    connections = data.get('connections', [])
    if not any(conn.get('source') == source and conn.get('target') == target for conn in connections):
        print(f"[red]Connection '{source} -> {target}' not found.[/red]")
        sys.exit(1)
    data['connections'] = [conn for conn in connections if not (conn.get('source') == source and conn.get('target') == target)]
    save_knowledge_graph(data)
    print(f"[green]Connection '{source} -> {target}' removed successfully.[/green]")

# Função para validar grafo
def validate_graph():
    data = load_knowledge_graph()
    nodes = data.get('nodes', [])
    connections = data.get('connections', [])
    print("[bold]Validating knowledge graph...[/bold]")
    for node in nodes:
        if not node.get('id') or not node.get('type'):
            print(f"[red]Invalid node: {node}[/red]")
            sys.exit(1)
    for conn in connections:
        if not conn.get('source') or not conn.get('target') or not conn.get('type'):
            print(f"[red]Invalid connection: {conn}[/red]")
            sys.exit(1)
        if not any(node.get('id') == conn.get('source') for node in nodes) or not any(node.get('id') == conn.get('target') for node in nodes):
            print(f"[red]Connection references non-existent node: {conn}[/red]")
            sys.exit(1)
    print("[green]Knowledge graph validation completed successfully.[/green]")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GRUPO US VIBECODE SYSTEM - Knowledge Graph Manager (Python)")
    parser.add_argument("-a", "--action", choices=["list-nodes", "list-connections", "add-node", "add-connection", "remove-node", "remove-connection", "validate"], required=True, help="Ação a executar")
    parser.add_argument("-i", "--id", help="ID do nó")
    parser.add_argument("-t", "--type", help="Tipo do nó ou conexão")
    parser.add_argument("-s", "--source", help="Nó de origem da conexão")
    parser.add_argument("-g", "--target", help="Nó de destino da conexão")
    parser.add_argument("-p", "--properties", help="Propriedades em formato JSON")
    args = parser.parse_args()

    if args.action == "list-nodes":
        list_nodes()
    elif args.action == "list-connections":
        list_connections()
    elif args.action == "add-node":
        if not args.id or not args.type:
            print("[red]É necessário informar o ID e o tipo do nó com -i e -t[/red]")
            sys.exit(1)
        properties = json.loads(args.properties) if args.properties else {}
        add_node(args.id, args.type, properties)
    elif args.action == "add-connection":
        if not args.source or not args.target or not args.type:
            print("[red]É necessário informar a origem, destino e tipo da conexão com -s, -g e -t[/red]")
            sys.exit(1)
        properties = json.loads(args.properties) if args.properties else {}
        add_connection(args.source, args.target, args.type, properties)
    elif args.action == "remove-node":
        if not args.id:
            print("[red]É necessário informar o ID do nó com -i[/red]")
            sys.exit(1)
        remove_node(args.id)
    elif args.action == "remove-connection":
        if not args.source or not args.target:
            print("[red]É necessário informar a origem e destino da conexão com -s e -g[/red]")
            sys.exit(1)
        remove_connection(args.source, args.target)
    elif args.action == "validate":
        validate_graph()
