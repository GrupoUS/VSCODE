#!/usr/bin/env python3
"""
🔧 ARGUMENT PARSER UTILITIES - VIBECODE SYSTEM V4.0

Módulo centralizado para parsing de argumentos padronizado.
Extraído dos scripts consolidados para reutilização.

Autor: GRUPO US - VIBECODE SYSTEM
Data: 2025-01-27
"""

import argparse
from typing import Dict, List, Any, Optional
from pathlib import Path


class VibeCodeArgumentParser:
    """
    Parser de argumentos padronizado para scripts VIBECODE.
    """
    
    def __init__(self, script_name: str, description: str):
        self.script_name = script_name
        self.parser = argparse.ArgumentParser(
            prog=script_name,
            description=f"🚀 VIBECODE System V4.0 - {description}",
            formatter_class=argparse.RawDescriptionHelpFormatter,
            epilog="""
Exemplos de uso:
  python {script_name} --help
  python {script_name} --verbose
  python {script_name} --config custom.json

GRUPO US VIBECODE SYSTEM V4.0
            """.format(script_name=script_name)
        )
        
        # Argumentos padrão para todos os scripts
        self._add_common_arguments()
    
    def _add_common_arguments(self):
        """Adiciona argumentos comuns a todos os scripts."""
        
        # Grupo de configuração geral
        general_group = self.parser.add_argument_group('Configuração Geral')
        
        general_group.add_argument(
            '--verbose', '-v',
            action='store_true',
            help='Ativar modo verbose (logging detalhado)'
        )
        
        general_group.add_argument(
            '--quiet', '-q',
            action='store_true',
            help='Modo silencioso (apenas erros)'
        )
        
        general_group.add_argument(
            '--config', '-c',
            type=str,
            help='Arquivo de configuração personalizado'
        )
        
        general_group.add_argument(
            '--log-file',
            type=str,
            help='Arquivo de log personalizado'
        )
        
        general_group.add_argument(
            '--dry-run',
            action='store_true',
            help='Executar em modo simulação (sem alterações)'
        )
        
        # Grupo de validação
        validation_group = self.parser.add_argument_group('Validação e Backup')
        
        validation_group.add_argument(
            '--backup-protection',
            action='store_true',
            help='Ativar proteção de backup antes de operações destrutivas'
        )
        
        validation_group.add_argument(
            '--memory-validation',
            action='store_true',
            help='Ativar validação do memory bank'
        )
        
        validation_group.add_argument(
            '--skip-validation',
            action='store_true',
            help='Pular validações (uso avançado)'
        )
    
    def add_level_argument(self, levels: List[str], default: str = None):
        """
        Adiciona argumento de nível (ex: basic, enhanced, comprehensive).
        
        Args:
            levels: Lista de níveis disponíveis
            default: Nível padrão
        """
        self.parser.add_argument(
            '--level',
            choices=levels,
            default=default or levels[0],
            help=f'Nível de execução: {", ".join(levels)}'
        )
    
    def add_target_argument(self, targets: List[str], multiple: bool = True):
        """
        Adiciona argumento de alvo/target.
        
        Args:
            targets: Lista de alvos disponíveis
            multiple: Se permite múltiplos alvos
        """
        if multiple:
            self.parser.add_argument(
                '--target',
                choices=targets + ['all'],
                nargs='*',
                default=['all'],
                help=f'Alvos: {", ".join(targets)}, all'
            )
        else:
            self.parser.add_argument(
                '--target',
                choices=targets,
                default=targets[0],
                help=f'Alvo: {", ".join(targets)}'
            )
    
    def add_type_argument(self, types: List[str], default: str = None):
        """
        Adiciona argumento de tipo.
        
        Args:
            types: Lista de tipos disponíveis
            default: Tipo padrão
        """
        self.parser.add_argument(
            '--type',
            choices=types,
            default=default or types[0],
            help=f'Tipo: {", ".join(types)}'
        )
    
    def add_component_argument(self, components: List[str]):
        """
        Adiciona argumento de componente.
        
        Args:
            components: Lista de componentes disponíveis
        """
        self.parser.add_argument(
            '--component',
            choices=components,
            help=f'Componente: {", ".join(components)}'
        )
    
    def add_report_argument(self):
        """Adiciona argumentos relacionados a relatórios."""
        report_group = self.parser.add_argument_group('Relatórios')
        
        report_group.add_argument(
            '--report',
            action='store_true',
            help='Gerar relatório detalhado'
        )
        
        report_group.add_argument(
            '--report-format',
            choices=['json', 'markdown', 'text'],
            default='json',
            help='Formato do relatório'
        )
        
        report_group.add_argument(
            '--report-file',
            type=str,
            help='Arquivo de relatório personalizado'
        )
    
    def add_force_argument(self):
        """Adiciona argumento --force."""
        self.parser.add_argument(
            '--force',
            action='store_true',
            help='Forçar execução (ignorar avisos)'
        )
    
    def add_custom_argument(self, *args, **kwargs):
        """
        Adiciona argumento personalizado.
        
        Args:
            *args: Argumentos posicionais para add_argument
            **kwargs: Argumentos nomeados para add_argument
        """
        return self.parser.add_argument(*args, **kwargs)
    
    def parse_args(self, args: Optional[List[str]] = None) -> argparse.Namespace:
        """
        Faz o parsing dos argumentos.
        
        Args:
            args: Lista de argumentos (None para sys.argv)
        
        Returns:
            Namespace com argumentos parseados
        """
        parsed_args = self.parser.parse_args(args)
        
        # Validações pós-parsing
        self._validate_args(parsed_args)
        
        return parsed_args
    
    def _validate_args(self, args: argparse.Namespace):
        """
        Valida argumentos após parsing.
        
        Args:
            args: Argumentos parseados
        """
        # Validar conflitos
        if hasattr(args, 'verbose') and hasattr(args, 'quiet'):
            if args.verbose and args.quiet:
                self.parser.error("--verbose e --quiet são mutuamente exclusivos")
        
        # Validar arquivos de configuração
        if hasattr(args, 'config') and args.config:
            config_path = Path(args.config)
            if not config_path.exists():
                self.parser.error(f"Arquivo de configuração não encontrado: {args.config}")
        
        # Validar diretórios de log
        if hasattr(args, 'log_file') and args.log_file:
            log_path = Path(args.log_file)
            log_path.parent.mkdir(parents=True, exist_ok=True)


def create_test_parser() -> VibeCodeArgumentParser:
    """Cria parser para scripts de teste."""
    parser = VibeCodeArgumentParser("run_tests", "Suite de testes e validação")
    
    parser.add_level_argument(['basic', 'enhanced', 'comprehensive'], 'basic')
    parser.add_report_argument()
    
    return parser


def create_sync_parser() -> VibeCodeArgumentParser:
    """Cria parser para scripts de sincronização."""
    parser = VibeCodeArgumentParser("sync", "Sincronização Git")
    
    parser.add_target_argument(['all', 'specific', 'existing'], multiple=False)
    parser.add_force_argument()
    
    # Argumentos específicos de sync
    parser.add_custom_argument(
        '--auto-push',
        action='store_true',
        help='Push automático após sync'
    )
    
    parser.add_custom_argument(
        '--quick-push',
        action='store_true',
        help='Push rápido sem validação completa'
    )
    
    return parser


def create_maintenance_parser() -> VibeCodeArgumentParser:
    """Cria parser para scripts de manutenção."""
    parser = VibeCodeArgumentParser("maintenance", "Sistema de backup e limpeza")
    
    parser.add_type_argument(['backup', 'cleanup', 'consolidate'])
    parser.add_force_argument()
    
    # Argumentos específicos de manutenção
    parser.add_custom_argument(
        '--size-limit',
        type=str,
        default='100MB',
        help='Limite de tamanho para operações'
    )
    
    parser.add_custom_argument(
        '--exclude',
        nargs='*',
        help='Padrões de exclusão'
    )
    
    return parser


def create_monitor_parser() -> VibeCodeArgumentParser:
    """Cria parser para scripts de monitoramento."""
    parser = VibeCodeArgumentParser("monitor", "Monitoramento de sistema")
    
    parser.add_type_argument(['structure', 'performance', 'sync'])
    parser.add_report_argument()
    
    # Argumentos específicos de monitoramento
    parser.add_custom_argument(
        '--continuous',
        action='store_true',
        help='Monitoramento contínuo'
    )
    
    parser.add_custom_argument(
        '--interval',
        type=int,
        default=60,
        help='Intervalo de monitoramento (segundos)'
    )
    
    return parser


def create_setup_parser() -> VibeCodeArgumentParser:
    """Cria parser para scripts de setup."""
    parser = VibeCodeArgumentParser("setup", "Configuração e setup")
    
    parser.add_component_argument(['sync', 'optimization', 'workflow', 'git', 'structure'])
    parser.add_force_argument()
    
    # Argumentos específicos de setup
    parser.add_custom_argument(
        '--validate',
        action='store_true',
        help='Apenas validar configuração'
    )
    
    return parser


# Função de conveniência para obter parser por nome
def get_parser(script_name: str) -> VibeCodeArgumentParser:
    """
    Obtém parser pré-configurado por nome do script.
    
    Args:
        script_name: Nome do script
    
    Returns:
        Parser configurado
    """
    parsers = {
        'run_tests': create_test_parser,
        'sync': create_sync_parser,
        'maintenance': create_maintenance_parser,
        'monitor': create_monitor_parser,
        'setup': create_setup_parser
    }
    
    if script_name in parsers:
        return parsers[script_name]()
    else:
        # Parser genérico
        return VibeCodeArgumentParser(script_name, f"Script {script_name}")


# Exemplo de uso:
if __name__ == "__main__":
    # Teste do módulo
    parser = create_test_parser()
    args = parser.parse_args(['--level', 'comprehensive', '--report', '--verbose'])
    
    print(f"✅ Argumentos parseados: {vars(args)}")
    print("✅ Argument parser utils testado com sucesso!")
