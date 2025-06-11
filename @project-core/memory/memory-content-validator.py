#!/usr/bin/env python3

"""
MEMORY CONTENT VALIDATOR
GRUPO US VIBECODE SYSTEM - Native RAG System V1.0

Sistema inteligente para validar conteúdo antes de adicionar aos arquivos de memória,
prevenindo duplicações, redundâncias e informações obsoletas.
"""

import os
import re
import hashlib
from pathlib import Path
from typing import List, Dict, Any, Set
from datetime import datetime
import difflib

class MemoryContentValidator:
    """
    Validador inteligente de conteúdo para arquivos de memória
    """
    
    def __init__(self):
        self.project_root = Path(__file__).parent
        
        # Arquivos de memória principais
        self.memory_files = {
            'augment_memories': Path("C:/Users/Admin/AppData/Roaming/Code/User/workspaceStorage/f93728a73b8802154d6c1bd441b921c0/Augment.vscode-augment/Augment-Memories"),
            'self_correction_log': self.project_root / 'self_correction_log.md'
        }
        
        # Configuração de validação
        self.config = {
            'similarity_threshold': 0.8,  # 80% similaridade = duplicação
            'min_content_length': 50,     # Mínimo 50 caracteres
            'max_content_length': 2000,   # Máximo 2000 caracteres por entrada
            'obsolete_keywords': [
                'TaskMaster', 'task-master', 'taskmaster',
                'deprecated', 'obsolete', 'removed'
            ],
            'required_quality_score': 0.7  # Mínimo 70% qualidade
        }
        
        # Cache de conteúdo existente
        self.existing_content = {}
        self.content_hashes = set()
        
    def load_existing_content(self):
        """Carrega conteúdo existente dos arquivos de memória"""
        self.existing_content = {}
        self.content_hashes = set()
        
        for file_type, file_path in self.memory_files.items():
            if file_path.exists():
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Parse content based on file type
                    if file_type == 'augment_memories':
                        entries = self._parse_augment_preferences(content)
                    else:
                        entries = self._parse_self_correction_entries(content)
                    
                    self.existing_content[file_type] = entries
                    
                    # Generate hashes for duplicate detection
                    for entry in entries:
                        content_hash = hashlib.md5(entry.lower().strip().encode()).hexdigest()
                        self.content_hashes.add(content_hash)
                        
                except Exception as e:
                    print(f"⚠️ Error loading {file_type}: {e}")
    
    def _parse_augment_preferences(self, content: str) -> List[str]:
        """Parse Augment preferences into individual entries"""
        entries = []
        lines = content.split('\n')
        
        for line in lines:
            line = line.strip()
            if line.startswith('- User prefers') or line.startswith('- User requires'):
                entries.append(line)
        
        return entries
    
    def _parse_self_correction_entries(self, content: str) -> List[str]:
        """Parse self correction log into individual entries"""
        entries = []
        
        # Split by headers (## or ###)
        sections = re.split(r'^#{2,3}\s+', content, flags=re.MULTILINE)
        
        for section in sections:
            if len(section.strip()) > self.config['min_content_length']:
                entries.append(section.strip())
        
        return entries
    
    def validate_new_content(self, new_content: str, target_file: str) -> Dict[str, Any]:
        """
        Valida novo conteúdo antes de adicionar ao arquivo de memória
        
        Args:
            new_content: Conteúdo a ser validado
            target_file: Arquivo de destino ('augment_memories' ou 'self_correction_log')
            
        Returns:
            Resultado da validação com recomendações
        """
        # Load existing content if not already loaded
        if not self.existing_content:
            self.load_existing_content()
        
        validation_result = {
            'is_valid': True,
            'issues': [],
            'recommendations': [],
            'quality_score': 0.0,
            'similarity_matches': [],
            'processed_content': new_content
        }
        
        # 1. Basic content validation
        basic_validation = self._validate_basic_content(new_content)
        validation_result.update(basic_validation)
        
        # 2. Duplicate detection
        duplicate_check = self._check_duplicates(new_content, target_file)
        validation_result['similarity_matches'] = duplicate_check['matches']
        if duplicate_check['is_duplicate']:
            validation_result['is_valid'] = False
            validation_result['issues'].append("Content is duplicate or highly similar to existing content")
        
        # 3. Obsolete content detection
        obsolete_check = self._check_obsolete_content(new_content)
        if obsolete_check['has_obsolete']:
            validation_result['is_valid'] = False
            validation_result['issues'].extend(obsolete_check['issues'])
        
        # 4. Quality assessment
        quality_score = self._assess_content_quality(new_content)
        validation_result['quality_score'] = quality_score
        
        if quality_score < self.config['required_quality_score']:
            validation_result['is_valid'] = False
            validation_result['issues'].append(f"Content quality score ({quality_score:.2f}) below required threshold ({self.config['required_quality_score']})")
        
        # 5. Generate recommendations
        validation_result['recommendations'] = self._generate_recommendations(validation_result)
        
        return validation_result
    
    def _validate_basic_content(self, content: str) -> Dict[str, Any]:
        """Validação básica de conteúdo"""
        issues = []
        
        # Length validation
        if len(content) < self.config['min_content_length']:
            issues.append(f"Content too short (minimum {self.config['min_content_length']} characters)")
        
        if len(content) > self.config['max_content_length']:
            issues.append(f"Content too long (maximum {self.config['max_content_length']} characters)")
        
        # Empty or whitespace only
        if not content.strip():
            issues.append("Content is empty or contains only whitespace")
        
        return {'basic_issues': issues}
    
    def _check_duplicates(self, new_content: str, target_file: str) -> Dict[str, Any]:
        """Verifica duplicações usando similaridade de texto"""
        matches = []
        is_duplicate = False
        
        # Generate hash for exact duplicate detection
        content_hash = hashlib.md5(new_content.lower().strip().encode()).hexdigest()
        
        if content_hash in self.content_hashes:
            is_duplicate = True
            matches.append({
                'type': 'exact_duplicate',
                'similarity': 1.0,
                'content': 'Exact duplicate found'
            })
        
        # Check similarity with existing content
        if target_file in self.existing_content:
            for existing_entry in self.existing_content[target_file]:
                similarity = difflib.SequenceMatcher(None, new_content.lower(), existing_entry.lower()).ratio()
                
                if similarity >= self.config['similarity_threshold']:
                    is_duplicate = True
                    matches.append({
                        'type': 'similar_content',
                        'similarity': similarity,
                        'content': existing_entry[:100] + '...' if len(existing_entry) > 100 else existing_entry
                    })
        
        return {
            'is_duplicate': is_duplicate,
            'matches': matches
        }
    
    def _check_obsolete_content(self, content: str) -> Dict[str, Any]:
        """Verifica conteúdo obsoleto"""
        issues = []
        has_obsolete = False
        
        content_lower = content.lower()
        
        for keyword in self.config['obsolete_keywords']:
            if keyword.lower() in content_lower:
                has_obsolete = True
                issues.append(f"Contains obsolete keyword: '{keyword}'")
        
        return {
            'has_obsolete': has_obsolete,
            'issues': issues
        }
    
    def _assess_content_quality(self, content: str) -> float:
        """Avalia qualidade do conteúdo"""
        score = 0.0
        
        # Length score (optimal range: 100-500 characters)
        length = len(content)
        if 100 <= length <= 500:
            score += 0.3
        elif 50 <= length < 100 or 500 < length <= 1000:
            score += 0.2
        elif length > 1000:
            score += 0.1
        
        # Structure score
        if content.startswith('- User prefers') or content.startswith('- User requires'):
            score += 0.2
        
        if '##' in content or '###' in content:  # Has headers
            score += 0.1
        
        # Information density score
        words = content.split()
        if len(words) >= 10:
            score += 0.2
        
        # Technical relevance score
        technical_keywords = ['MCP', 'Sequential Thinking', 'performance', 'optimization', 'validation', 'system']
        keyword_count = sum(1 for keyword in technical_keywords if keyword.lower() in content.lower())
        score += min(0.2, keyword_count * 0.05)
        
        return min(1.0, score)
    
    def _generate_recommendations(self, validation_result: Dict[str, Any]) -> List[str]:
        """Gera recomendações baseadas na validação"""
        recommendations = []
        
        if validation_result['quality_score'] < 0.5:
            recommendations.append("Consider adding more specific technical details")
        
        if validation_result['similarity_matches']:
            recommendations.append("Review similar existing content to avoid redundancy")
        
        if 'basic_issues' in validation_result and validation_result['basic_issues']:
            recommendations.append("Address basic content issues before adding to memory")
        
        if validation_result['quality_score'] >= 0.8:
            recommendations.append("High quality content - suitable for memory addition")
        
        return recommendations
    
    def suggest_content_optimization(self, content: str) -> str:
        """Sugere otimizações para o conteúdo"""
        optimized = content.strip()
        
        # Remove redundant whitespace
        optimized = re.sub(r'\s+', ' ', optimized)
        
        # Ensure proper formatting for preferences
        if not optimized.startswith('- '):
            optimized = f"- {optimized}"
        
        return optimized
    
    def get_memory_statistics(self) -> Dict[str, Any]:
        """Retorna estatísticas dos arquivos de memória"""
        if not self.existing_content:
            self.load_existing_content()
        
        stats = {}
        
        for file_type, entries in self.existing_content.items():
            file_path = self.memory_files[file_type]
            file_size = file_path.stat().st_size if file_path.exists() else 0
            
            stats[file_type] = {
                'entries_count': len(entries),
                'file_size_bytes': file_size,
                'file_size_kb': file_size / 1024,
                'avg_entry_length': sum(len(entry) for entry in entries) / len(entries) if entries else 0,
                'last_modified': file_path.stat().st_mtime if file_path.exists() else 0
            }
        
        return stats

def main():
    """Função principal para teste do validador"""
    validator = MemoryContentValidator()
    
    print("🔍 MEMORY CONTENT VALIDATOR")
    print("=" * 50)
    
    # Load existing content
    validator.load_existing_content()
    
    # Show statistics
    stats = validator.get_memory_statistics()
    
    for file_type, file_stats in stats.items():
        print(f"\n📊 {file_type.upper()}:")
        print(f"  Entries: {file_stats['entries_count']}")
        print(f"  Size: {file_stats['file_size_kb']:.1f}KB")
        print(f"  Avg entry length: {file_stats['avg_entry_length']:.0f} chars")
    
    # Example validation
    test_content = "- User prefers using Sequential Thinking MCP for complex tasks with validation protocols"
    
    print(f"\n🧪 Testing validation:")
    result = validator.validate_new_content(test_content, 'augment_memories')
    
    print(f"  Valid: {result['is_valid']}")
    print(f"  Quality Score: {result['quality_score']:.2f}")
    print(f"  Issues: {len(result['issues'])}")
    print(f"  Recommendations: {len(result['recommendations'])}")

if __name__ == "__main__":
    main()
