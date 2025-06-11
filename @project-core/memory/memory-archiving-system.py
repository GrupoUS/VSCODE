#!/usr/bin/env python3

"""
MEMORY ARCHIVING SYSTEM
GRUPO US VIBECODE SYSTEM - Native RAG System V1.0

Automated archiving system for self_correction_log.md to maintain performance
while preserving historical data. Implements the optimization strategy from
the Memory System Audit.
"""

import os
import re
import gzip
import json
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Dict, Any

class MemoryArchivingSystem:
    """
    Automated archiving system for memory files to optimize performance
    """
    
    def __init__(self):
        self.project_root = Path(__file__).parent
        self.memory_dir = self.project_root
        self.archive_dir = self.memory_dir / 'archives'
        self.archive_dir.mkdir(exist_ok=True)
        
        # Configuration
        self.config = {
            'active_retention_days': 180,  # 6 months
            'archive_compression': True,
            'create_index': True,
            'backup_before_archive': True,
            'performance_target_kb': 100,  # Target: <100KB for active file
            'max_active_entries': 500      # Max entries in active file
        }
        
        # File paths
        self.self_correction_log = self.memory_dir / 'self_correction_log.md'
        self.active_log = self.memory_dir / 'self_correction_log_active.md'
        self.archive_index = self.archive_dir / 'archive_index.json'
        
    def analyze_current_file(self) -> Dict[str, Any]:
        """Analyze current self_correction_log.md for archiving opportunities"""
        if not self.self_correction_log.exists():
            return {'error': 'self_correction_log.md not found'}
        
        with open(self.self_correction_log, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Parse entries by date
        entries = self._parse_log_entries(content)
        
        # Calculate metrics
        file_size_kb = len(content.encode('utf-8')) / 1024
        total_entries = len(entries)
        
        # Identify archivable entries (older than retention period)
        cutoff_date = datetime.now() - timedelta(days=self.config['active_retention_days'])
        archivable_entries = [e for e in entries if e['date'] < cutoff_date]
        active_entries = [e for e in entries if e['date'] >= cutoff_date]
        
        return {
            'file_size_kb': file_size_kb,
            'total_entries': total_entries,
            'archivable_entries': len(archivable_entries),
            'active_entries': len(active_entries),
            'archiving_recommended': (
                file_size_kb > self.config['performance_target_kb'] or 
                total_entries > self.config['max_active_entries']
            ),
            'potential_size_reduction_percent': (len(archivable_entries) / total_entries * 100) if total_entries > 0 else 0
        }
    
    def _parse_log_entries(self, content: str) -> List[Dict[str, Any]]:
        """Parse log entries from content"""
        entries = []
        
        # Pattern to match date headers (## YYYY-MM-DD format)
        date_pattern = r'^## (\d{4}-\d{2}-\d{2})'
        
        lines = content.split('\n')
        current_entry = None
        
        for i, line in enumerate(lines):
            date_match = re.match(date_pattern, line)
            
            if date_match:
                # Save previous entry
                if current_entry:
                    entries.append(current_entry)
                
                # Start new entry
                date_str = date_match.group(1)
                try:
                    entry_date = datetime.strptime(date_str, '%Y-%m-%d')
                except ValueError:
                    # Try alternative date formats
                    try:
                        entry_date = datetime.strptime(date_str, '%Y-%m-%d')
                    except ValueError:
                        entry_date = datetime.now()  # Fallback
                
                current_entry = {
                    'date': entry_date,
                    'date_str': date_str,
                    'start_line': i,
                    'content_lines': [line]
                }
            elif current_entry:
                current_entry['content_lines'].append(line)
        
        # Add last entry
        if current_entry:
            entries.append(current_entry)
        
        # Calculate content for each entry
        for entry in entries:
            entry['content'] = '\n'.join(entry['content_lines'])
            entry['size_bytes'] = len(entry['content'].encode('utf-8'))
        
        return entries
    
    def create_archive(self, archive_name: str = None) -> Dict[str, Any]:
        """Create archive of old entries"""
        if archive_name is None:
            archive_name = f"archive_{datetime.now().strftime('%Y_%m_%d')}"
        
        # Analyze current file
        analysis = self.analyze_current_file()
        
        if not analysis.get('archiving_recommended', False):
            return {
                'status': 'skipped',
                'reason': 'Archiving not recommended',
                'analysis': analysis
            }
        
        # Backup original file
        if self.config['backup_before_archive']:
            backup_path = self.memory_dir / f'self_correction_log_backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}.md'
            with open(self.self_correction_log, 'r', encoding='utf-8') as src:
                with open(backup_path, 'w', encoding='utf-8') as dst:
                    dst.write(src.read())
        
        # Parse entries
        with open(self.self_correction_log, 'r', encoding='utf-8') as f:
            content = f.read()
        
        entries = self._parse_log_entries(content)
        
        # Separate archivable and active entries
        cutoff_date = datetime.now() - timedelta(days=self.config['active_retention_days'])
        archivable_entries = [e for e in entries if e['date'] < cutoff_date]
        active_entries = [e for e in entries if e['date'] >= cutoff_date]
        
        # Create archive file
        archive_content = self._create_archive_content(archivable_entries)
        archive_path = self.archive_dir / f'{archive_name}.md'
        
        with open(archive_path, 'w', encoding='utf-8') as f:
            f.write(archive_content)
        
        # Compress archive if enabled
        if self.config['archive_compression']:
            compressed_path = self.archive_dir / f'{archive_name}.md.gz'
            with open(archive_path, 'rb') as f_in:
                with gzip.open(compressed_path, 'wb') as f_out:
                    f_out.write(f_in.read())
            
            # Remove uncompressed version
            archive_path.unlink()
            archive_path = compressed_path
        
        # Create new active file
        active_content = self._create_active_content(active_entries)
        
        with open(self.active_log, 'w', encoding='utf-8') as f:
            f.write(active_content)
        
        # Update archive index
        self._update_archive_index(archive_name, archivable_entries, archive_path)
        
        # Calculate results
        original_size = len(content.encode('utf-8'))
        new_size = len(active_content.encode('utf-8'))
        size_reduction = ((original_size - new_size) / original_size * 100) if original_size > 0 else 0
        
        return {
            'status': 'success',
            'archive_name': archive_name,
            'archive_path': str(archive_path),
            'entries_archived': len(archivable_entries),
            'entries_active': len(active_entries),
            'original_size_kb': original_size / 1024,
            'new_size_kb': new_size / 1024,
            'size_reduction_percent': size_reduction,
            'backup_created': str(backup_path) if self.config['backup_before_archive'] else None
        }
    
    def _create_archive_content(self, entries: List[Dict[str, Any]]) -> str:
        """Create content for archive file"""
        header = f"""# ARCHIVED MEMORY LOG
# Archive created: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
# Entries: {len(entries)}
# Date range: {entries[0]['date_str'] if entries else 'N/A'} to {entries[-1]['date_str'] if entries else 'N/A'}

---

"""
        
        content_parts = [header]
        for entry in entries:
            content_parts.append(entry['content'])
            content_parts.append('\n---\n')
        
        return '\n'.join(content_parts)
    
    def _create_active_content(self, entries: List[Dict[str, Any]]) -> str:
        """Create content for active file"""
        header = f"""# 🧠 SELF-CORRECTION LOG - ACTIVE ENTRIES
# GRUPO US VIBECODE SYSTEM V3.1 - Enhanced Memory System V4.0

## 📋 OVERVIEW

Este arquivo contém apenas as entradas ativas dos últimos {self.config['active_retention_days']} dias.
Entradas mais antigas foram arquivadas para otimização de performance.

**Última otimização**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
**Entradas ativas**: {len(entries)}

---

"""
        
        content_parts = [header]
        for entry in entries:
            content_parts.append(entry['content'])
            content_parts.append('\n')
        
        return '\n'.join(content_parts)
    
    def _update_archive_index(self, archive_name: str, entries: List[Dict[str, Any]], archive_path: Path):
        """Update archive index for fast searching"""
        # Load existing index
        index = {}
        if self.archive_index.exists():
            with open(self.archive_index, 'r', encoding='utf-8') as f:
                index = json.load(f)
        
        # Add new archive
        index[archive_name] = {
            'created': datetime.now().isoformat(),
            'path': str(archive_path),
            'entries_count': len(entries),
            'date_range': {
                'start': entries[0]['date_str'] if entries else None,
                'end': entries[-1]['date_str'] if entries else None
            },
            'size_bytes': archive_path.stat().st_size if archive_path.exists() else 0,
            'compressed': archive_path.suffix == '.gz'
        }
        
        # Save updated index
        with open(self.archive_index, 'w', encoding='utf-8') as f:
            json.dump(index, f, indent=2)
    
    def get_optimization_report(self) -> Dict[str, Any]:
        """Generate optimization report"""
        analysis = self.analyze_current_file()
        
        return {
            'current_status': analysis,
            'recommendations': self._generate_recommendations(analysis),
            'archive_index': self._load_archive_index()
        }
    
    def _generate_recommendations(self, analysis: Dict[str, Any]) -> List[str]:
        """Generate optimization recommendations"""
        recommendations = []
        
        if analysis.get('file_size_kb', 0) > self.config['performance_target_kb']:
            recommendations.append(f"File size ({analysis['file_size_kb']:.1f}KB) exceeds target ({self.config['performance_target_kb']}KB). Archive recommended.")
        
        if analysis.get('total_entries', 0) > self.config['max_active_entries']:
            recommendations.append(f"Entry count ({analysis['total_entries']}) exceeds target ({self.config['max_active_entries']}). Archive recommended.")
        
        if analysis.get('potential_size_reduction_percent', 0) > 30:
            recommendations.append(f"Potential size reduction: {analysis['potential_size_reduction_percent']:.1f}%. Significant optimization possible.")
        
        if not recommendations:
            recommendations.append("File is within optimal parameters. No immediate archiving needed.")
        
        return recommendations
    
    def _load_archive_index(self) -> Dict[str, Any]:
        """Load archive index"""
        if self.archive_index.exists():
            with open(self.archive_index, 'r', encoding='utf-8') as f:
                return json.load(f)
        return {}

def main():
    """Main execution function"""
    archiver = MemoryArchivingSystem()
    
    print("🔍 MEMORY SYSTEM OPTIMIZATION")
    print("=" * 50)
    
    # Generate report
    report = archiver.get_optimization_report()
    
    print(f"📊 Current Status:")
    print(f"  File size: {report['current_status'].get('file_size_kb', 0):.1f}KB")
    print(f"  Total entries: {report['current_status'].get('total_entries', 0)}")
    print(f"  Archivable entries: {report['current_status'].get('archivable_entries', 0)}")
    
    print(f"\n📋 Recommendations:")
    for rec in report['recommendations']:
        print(f"  • {rec}")
    
    # Execute archiving if recommended
    if report['current_status'].get('archiving_recommended', False):
        print(f"\n🔧 Executing archiving...")
        result = archiver.create_archive()
        
        if result['status'] == 'success':
            print(f"✅ Archiving completed successfully!")
            print(f"  Entries archived: {result['entries_archived']}")
            print(f"  Size reduction: {result['size_reduction_percent']:.1f}%")
            print(f"  Archive: {result['archive_path']}")
        else:
            print(f"⚠️ Archiving skipped: {result.get('reason', 'Unknown')}")
    else:
        print(f"\n✅ No archiving needed at this time.")

if __name__ == "__main__":
    main()
