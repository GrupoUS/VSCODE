#!/usr/bin/env python3
"""
invoke-shrimp-workflow.py
Script para iniciar o mcp-shrimp-task-manager com um workflow e objetivo específicos.
Uso: python invoke-shrimp-workflow.py <workflow_id> <objetivo>
"""
import sys
import subprocess
import os
import json
import argparse
from typing import Dict, List, Optional, Union

# Caminho absoluto para o diretório de dados do Shrimp
DATA_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../@project-core/memory/shrimp-tasks'))

# Configuração do ambiente
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONFIG_PATH = os.path.join(PROJECT_ROOT, "memory", "coordination", "shrimp-task-manager-config.json")
WORKFLOW_PATH = os.path.join(PROJECT_ROOT, "agents", "workflows", "standard-workflows.json")

def load_config(config_path: str) -> Dict:
    """Carrega a configuração do Shrimp Task Manager."""
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Erro ao carregar configuração: {e}")
        sys.exit(1)

def load_workflow(workflow_path: str) -> Dict:
    """Carrega o workflow padrão."""
    try:
        with open(workflow_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Erro ao carregar workflow: {e}")
        sys.exit(1)

def validate_task(task: Dict) -> bool:
    """Valida a estrutura da tarefa."""
    required_fields = ["task_id", "description", "complexity", "deliverables"]
    return all(field in task for field in required_fields)

def prepare_task_for_shrimp(task: Dict, config: Dict) -> Dict:
    """Prepara a tarefa para o Shrimp Task Manager."""
    return {
        "task_id": task["task_id"],
        "description": task["description"],
        "complexity": task["complexity"],
        "deliverables": task["deliverables"],
        "config": {
            "ENABLE_THOUGHT_CHAIN": config["ENABLE_THOUGHT_CHAIN"],
            "MAX_ITERATIONS": config["MAX_ITERATIONS"],
            "CONFIDENCE_THRESHOLD": config["CONFIDENCE_THRESHOLD"],
            "VERBOSE_MODE": config["VERBOSE_MODE"]
        }
    }

def invoke_shrimp_task_manager(task: Dict, config: Dict) -> Dict:
    """Invoca o Shrimp Task Manager para executar a tarefa."""
    try:
        # Aqui você implementaria a lógica real de invocação do Shrimp Task Manager
        # Por enquanto, apenas simulamos o retorno
        return {
            "status": "success",
            "task_id": task["task_id"],
            "result": {
                "completed": True,
                "deliverables": task["deliverables"],
                "metrics": {
                    "execution_time": "2.5s",
                    "confidence": 0.95,
                    "iterations": 3
                }
            }
        }
    except Exception as e:
        return {
            "status": "error",
            "task_id": task["task_id"],
            "error": str(e)
        }

def main():
    parser = argparse.ArgumentParser(description="Invoca o Shrimp Task Manager para executar tarefas")
    parser.add_argument("--task-id", help="ID da tarefa a ser executada")
    parser.add_argument("--workflow", help="Caminho para o arquivo de workflow")
    parser.add_argument("--config", help="Caminho para o arquivo de configuração")
    args = parser.parse_args()

    # Carrega configurações
    config = load_config(args.config or CONFIG_PATH)
    workflow = load_workflow(args.workflow or WORKFLOW_PATH)

    # Encontra a tarefa
    task = None
    if args.task_id:
        for phase in workflow["workflow_phases"]:
            for t in phase["tasks"]:
                if t["task_id"] == args.task_id:
                    task = t
                    break
            if task:
                break

    if not task:
        print(f"Tarefa {args.task_id} não encontrada")
        sys.exit(1)

    # Valida a tarefa
    if not validate_task(task):
        print("Estrutura da tarefa inválida")
        sys.exit(1)

    # Prepara e executa a tarefa
    prepared_task = prepare_task_for_shrimp(task, config)
    result = invoke_shrimp_task_manager(prepared_task, config)

    # Exibe o resultado
    print(json.dumps(result, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
