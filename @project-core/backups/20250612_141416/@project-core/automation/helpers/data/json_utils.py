#!/usr/bin/env python3
"""
🔧 JSON UTILITIES - VIBECODE SYSTEM V4.0

Módulo centralizado para operações JSON padronizadas.
Extraído dos scripts consolidados para reutilização.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import json
from pathlib import Path
from typing import Dict, List, Any, Optional, Union, Tuple
from datetime import datetime


def safe_load_json(file_path: Union[str, Path], default: Any = None) -> Any:
    """
    Carrega arquivo JSON com segurança.

    Args:
        file_path: Caminho do arquivo
        default: Valor padrão se falhar

    Returns:
        Dados JSON ou valor padrão
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError, PermissionError):
        return default


def safe_save_json(data: Any, file_path: Union[str, Path], indent: int = 2, ensure_ascii: bool = False) -> bool:
    """
    Salva dados em arquivo JSON com segurança.

    Args:
        data: Dados a serem salvos
        file_path: Caminho do arquivo
        indent: Indentação
        ensure_ascii: Garantir ASCII

    Returns:
        True se bem-sucedido
    """
    try:
        file_path = Path(file_path)
        file_path.parent.mkdir(parents=True, exist_ok=True)

        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=indent, ensure_ascii=ensure_ascii)
        return True
    except (PermissionError, OSError):
        return False


def merge_json_configs(base_config: Dict, override_config: Dict) -> Dict:
    """
    Mescla configurações JSON.

    Args:
        base_config: Configuração base
        override_config: Configuração de override

    Returns:
        Configuração mesclada
    """
    result = base_config.copy()

    for key, value in override_config.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = merge_json_configs(result[key], value)
        else:
            result[key] = value

    return result


def validate_json_schema(data: Dict, required_fields: List[str]) -> Tuple[bool, List[str]]:
    """
    Valida esquema JSON básico.

    Args:
        data: Dados JSON
        required_fields: Campos obrigatórios

    Returns:
        Tupla (is_valid, missing_fields)
    """
    missing_fields = []

    for field in required_fields:
        if '.' in field:
            # Campo aninhado
            parts = field.split('.')
            current = data
            for part in parts:
                if isinstance(current, dict) and part in current:
                    current = current[part]
                else:
                    missing_fields.append(field)
                    break
        else:
            # Campo simples
            if field not in data:
                missing_fields.append(field)

    return len(missing_fields) == 0, missing_fields


def create_report_json(
    title: str,
    data: Dict,
    metadata: Optional[Dict] = None,
    timestamp: Optional[datetime] = None
) -> Dict:
    """
    Cria estrutura padrão de relatório JSON.

    Args:
        title: Título do relatório
        data: Dados do relatório
        metadata: Metadados adicionais
        timestamp: Timestamp (padrão: agora)

    Returns:
        Estrutura de relatório padronizada
    """
    if timestamp is None:
        timestamp = datetime.now()

    report = {
        "title": title,
        "timestamp": timestamp.isoformat(),
        "generated_by": "VIBECODE System V4.0",
        "data": data
    }

    if metadata:
        report["metadata"] = metadata

    return report


def extract_json_metrics(data: Dict) -> Dict[str, Any]:
    """
    Extrai métricas básicas de dados JSON.

    Args:
        data: Dados JSON

    Returns:
        Métricas extraídas
    """
    def count_items(obj, depth=0):
        if isinstance(obj, dict):
            return {
                "type": "object",
                "keys": len(obj),
                "depth": depth,
                "nested_objects": sum(1 for v in obj.values() if isinstance(v, dict)),
                "nested_arrays": sum(1 for v in obj.values() if isinstance(v, list))
            }
        elif isinstance(obj, list):
            return {
                "type": "array",
                "length": len(obj),
                "depth": depth,
                "item_types": list(set(type(item).__name__ for item in obj))
            }
        else:
            return {
                "type": type(obj).__name__,
                "depth": depth
            }

    return count_items(data)


# Exemplo de uso:
if __name__ == "__main__":
    # Teste do módulo
    test_data = {
        "name": "test",
        "version": "1.0",
        "config": {
            "enabled": True,
            "settings": ["a", "b", "c"]
        }
    }

    # Teste de salvamento e carregamento
    test_file = Path("test_config.json")

    if safe_save_json(test_data, test_file):
        loaded_data = safe_load_json(test_file)
        print(f"✅ JSON salvo e carregado: {loaded_data['name']}")

        # Limpeza
        test_file.unlink(missing_ok=True)

    # Teste de validação
    required = ["name", "version", "config.enabled"]
    is_valid, missing = validate_json_schema(test_data, required)
    print(f"✅ Validação: {is_valid}, Faltando: {missing}")

    # Teste de métricas
    metrics = extract_json_metrics(test_data)
    print(f"✅ Métricas: {metrics}")

    print("✅ JSON utils testado com sucesso!")
