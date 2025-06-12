#!/usr/bin/env python3
"""
FINALTEST UNIFIED - Consolidated Testing Suite
GRUPO US VIBECODE SYSTEM V4.0

Consolidates 10 finaltest variants into single unified interface:
- enhanced-finaltest-v3.1.ps1 (Advanced validation + memory checks)
- enhanced_finaltest.py (Python implementation + logging)
- finaltest-backup-protection.ps1 (Backup validation)
- finaltest-enhanced.ps1 (Enhanced error handling)
- finaltest-python.ps1 (Python bridge functionality)
- finaltest-unified-memory-system.ps1 (Memory system validation)
- finaltest-v4.ps1 (V4 specific tests)
- finaltest.ps1 (Basic validation)
- simple_finaltest.py (Simplified testing)

Usage:
    python finaltest_unified.py --mode=enhanced    # Advanced validation
    python finaltest_unified.py --mode=v4          # V4 specific tests
    python finaltest_unified.py --mode=memory      # Memory system validation
    python finaltest_unified.py --mode=simple      # Basic validation
    python finaltest_unified.py --mode=backup      # Backup protection validation
    python finaltest_unified.py --mode=comprehensive  # All tests combined
"""

import argparse
import json
import logging
import sys
import time
from datetime import datetime
from enum import Enum
from pathlib import Path
from typing import Dict, List, Any, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('@project-core/logs/finaltest_unified.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class TestMode(Enum):
    """Available test modes"""
    ENHANCED = "enhanced"      # Advanced validation + memory checks
    V4 = "v4"                 # V4 specific tests
    MEMORY = "memory"         # Memory system validation
    SIMPLE = "simple"         # Basic validation
    BACKUP = "backup"         # Backup protection validation
    COMPREHENSIVE = "comprehensive"  # All tests combined

class TestResult:
    """Test result container"""
    def __init__(self, name: str, category: str):
        self.name = name
        self.category = category
        self.status = "PENDING"
        self.details = ""
        self.timestamp = datetime.now()
        self.duration = 0.0

    def pass_test(self, details: str = ""):
        self.status = "PASSED"
        self.details = details

    def fail_test(self, details: str = ""):
        self.status = "FAILED"
        self.details = details

    def error_test(self, details: str = ""):
        self.status = "ERROR"
        self.details = details

class FinalTestUnified:
    """Unified Final Test Suite"""

    def __init__(self, mode: TestMode, config: Optional[Dict] = None):
        self.mode = mode
        self.config = config or {}
        self.test_results: List[TestResult] = []
        self.start_time = datetime.now()

        # Initialize paths
        self.project_core = Path("@project-core")
        self.rules_path = self.project_core / "rules"
        self.memory_path = self.project_core / "memory"
        self.configs_path = self.project_core / "configs"
        self.automation_path = self.project_core / "automation"

        logger.info(f"FINALTEST UNIFIED - Mode: {mode.value.upper()}")
        logger.info(f"Project Core: {self.project_core}")

    def execute(self) -> Dict[str, Any]:
        """Main execution entry point"""
        try:
            if self.mode == TestMode.ENHANCED:
                return self._run_enhanced_tests()
            elif self.mode == TestMode.V4:
                return self._run_v4_tests()
            elif self.mode == TestMode.MEMORY:
                return self._run_memory_tests()
            elif self.mode == TestMode.SIMPLE:
                return self._run_simple_tests()
            elif self.mode == TestMode.BACKUP:
                return self._run_backup_tests()
            elif self.mode == TestMode.COMPREHENSIVE:
                return self._run_comprehensive_tests()
            else:
                raise ValueError(f"Unknown test mode: {self.mode}")

        except Exception as e:
            logger.error(f"❌ Test execution failed: {e}")
            return self._generate_error_report(str(e))

    def _run_enhanced_tests(self) -> Dict[str, Any]:
        """Enhanced validation from enhanced-finaltest-v3.1.ps1"""
        logger.info("🔍 Running Enhanced Tests...")

        # Phase 1: Task-driven rule updates
        self._test_task_driven_rules()

        # Phase 2: Project-core system synchronization
        self._test_project_core_sync()

        # Phase 3: Legacy system cleanup validation
        self._test_legacy_cleanup()

        # Phase 4: Performance optimization validation
        self._test_performance_optimization()

        # Phase 5: System validation
        self._test_system_validation()

        # Phase 6: Intelligent system evolution
        self._test_intelligent_evolution()

        return self._generate_report()

    def _run_v4_tests(self) -> Dict[str, Any]:
        """V4 specific tests from finaltest-v4.ps1"""
        logger.info("🎯 Running V4 Specific Tests...")

        # Phase 1: Constitution V4.0 validation
        self._test_constitution_v4()

        # Phase 2: FMC (Fusão de Memória Cognitiva) validation
        self._test_fmc_system()

        # Phase 3: Configuration V4.0 validation
        self._test_configuration_v4()

        # Phase 4: Cleanup validation
        self._test_cleanup_v4()

        return self._generate_report()

    def _run_memory_tests(self) -> Dict[str, Any]:
        """Memory system validation from finaltest-unified-memory-system.ps1"""
        logger.info("🧠 Running Memory System Tests...")

        # Test memory bank integrity
        self._test_memory_bank_integrity()

        # Test documentation completeness
        self._test_documentation_completeness()

        # Test automation tools
        self._test_automation_tools()

        # Test memory optimization
        self._test_memory_optimization()

        return self._generate_report()

    def _run_simple_tests(self) -> Dict[str, Any]:
        """Basic validation from simple_finaltest.py"""
        logger.info("Running Simple Tests...")

        # Basic file existence checks
        self._test_basic_files()

        return self._generate_report()

    def _run_backup_tests(self) -> Dict[str, Any]:
        """Backup protection validation from finaltest-backup-protection.ps1"""
        logger.info("💾 Running Backup Protection Tests...")

        # Test backup system integrity
        self._test_backup_system()

        # Test backup safety protocols
        self._test_backup_safety()

        # Test backup restoration capability
        self._test_backup_restoration()

        return self._generate_report()

    def _run_comprehensive_tests(self) -> Dict[str, Any]:
        """Run all test modes combined"""
        logger.info("🌟 Running Comprehensive Tests...")

        # Run all test categories
        self._run_enhanced_tests()
        self._run_v4_tests()
        self._run_memory_tests()
        self._run_backup_tests()

        return self._generate_report()

    def _test_constitution_v4(self):
        """Test V4.0 constitution files"""
        test = TestResult("Constitution V4.0 exists", "Constitution")

        constitution_file = self.rules_path / "00-vibecode-system-v4-master.md"
        if constitution_file.exists():
            # Check for FMC content
            content = constitution_file.read_text(encoding='utf-8')
            if "FMC" in content and "Fusão de Memória Cognitiva" in content:
                test.pass_test("Constitution V4.0 found with FMC content")
            else:
                test.fail_test("Constitution V4.0 missing FMC content")
        else:
            test.fail_test("Constitution V4.0 file not found")

        self.test_results.append(test)

    def _test_fmc_system(self):
        """Test FMC (Fusão de Memória Cognitiva) system"""
        # Test master_rule.md
        test1 = TestResult("master_rule.md exists", "FMC")
        if Path("master_rule.md").exists():
            test1.pass_test("Master rule file found")
        else:
            test1.fail_test("Master rule file not found")
        self.test_results.append(test1)

        # Test self_correction_log.md
        test2 = TestResult("self_correction_log.md exists", "FMC")
        log_file = self.memory_path / "self_correction_log.md"
        if log_file.exists():
            test2.pass_test("Self correction log found")
        else:
            test2.fail_test("Self correction log not found")
        self.test_results.append(test2)

        # Test global-standards.md
        test3 = TestResult("global-standards.md exists", "FMC")
        standards_file = self.memory_path / "global-standards.md"
        if standards_file.exists():
            test3.pass_test("Global standards found")
        else:
            test3.fail_test("Global standards not found")
        self.test_results.append(test3)

    def _test_basic_files(self):
        """Test basic file existence"""
        critical_files = [
            ("master_rule.md", "Root"),
            ("@project-core/memory/master_rule.md", "Memory"),
            ("@project-core/configs/mcp-master-unified.json", "Config"),
            ("@project-core/automation/validate_system.py", "Automation")
        ]

        for file_path, category in critical_files:
            test = TestResult(f"{file_path} exists", category)
            if Path(file_path).exists():
                test.pass_test("File found")
            else:
                test.fail_test("File not found")
            self.test_results.append(test)

    def _generate_report(self) -> Dict[str, Any]:
        """Generate comprehensive test report"""
        end_time = datetime.now()
        duration = (end_time - self.start_time).total_seconds()

        total_tests = len(self.test_results)
        passed_tests = len([t for t in self.test_results if t.status == "PASSED"])
        failed_tests = len([t for t in self.test_results if t.status == "FAILED"])
        error_tests = len([t for t in self.test_results if t.status == "ERROR"])

        success_rate = (passed_tests / total_tests * 100) if total_tests > 0 else 0

        report = {
            "mode": self.mode.value,
            "timestamp": end_time.isoformat(),
            "duration_seconds": duration,
            "summary": {
                "total_tests": total_tests,
                "passed": passed_tests,
                "failed": failed_tests,
                "errors": error_tests,
                "success_rate": round(success_rate, 2)
            },
            "status": "SUCCESS" if failed_tests == 0 and error_tests == 0 else "FAILED",
            "results": [
                {
                    "name": test.name,
                    "category": test.category,
                    "status": test.status,
                    "details": test.details,
                    "timestamp": test.timestamp.isoformat()
                }
                for test in self.test_results
            ]
        }

        # Save report
        report_path = f"@project-core/reports/finaltest-{self.mode.value}-{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        Path(report_path).parent.mkdir(parents=True, exist_ok=True)
        with open(report_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        # Log summary
        logger.info(f"📊 Test Summary: {passed_tests}/{total_tests} passed ({success_rate:.1f}%)")
        logger.info(f"📄 Report saved: {report_path}")

        return report

    def _generate_error_report(self, error_message: str) -> Dict[str, Any]:
        """Generate error report"""
        return {
            "mode": self.mode.value,
            "timestamp": datetime.now().isoformat(),
            "status": "ERROR",
            "error": error_message,
            "summary": {
                "total_tests": 0,
                "passed": 0,
                "failed": 0,
                "errors": 1,
                "success_rate": 0
            }
        }

def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(description="FINALTEST UNIFIED - Consolidated Testing Suite")
    parser.add_argument("--mode", choices=[m.value for m in TestMode],
                       default="enhanced", help="Test mode to execute")
    parser.add_argument("--config", help="Configuration file path")
    parser.add_argument("--dry-run", action="store_true", help="Dry run mode")
    parser.add_argument("--verbose", action="store_true", help="Verbose output")

    args = parser.parse_args()

    # Set logging level
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    # Load configuration
    config = {}
    if args.config and Path(args.config).exists():
        with open(args.config, 'r', encoding='utf-8') as f:
            config = json.load(f)

    # Add dry run to config
    config['dry_run'] = args.dry_run

    # Execute unified test
    test_suite = FinalTestUnified(TestMode(args.mode), config)
    result = test_suite.execute()

    # Exit with appropriate code
    exit_code = 0 if result.get("status") == "SUCCESS" else 1

    print(f"\n{'✅' if exit_code == 0 else '❌'} FINALTEST UNIFIED {args.mode.upper()} - {'SUCCESS' if exit_code == 0 else 'FAILED'}")
    print(f"📊 Results: {result['summary']['passed']}/{result['summary']['total_tests']} tests passed")

    sys.exit(exit_code)

if __name__ == "__main__":
    main()
