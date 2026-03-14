# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Windows batch scripts for system administration and development environment management. The scripts are designed for Japanese Windows systems and include NAS mounting, Chocolatey package management, Docker operations, uv cache management, and development tool automation.

## Script Architecture

### NAS Mount System
- **nas_mount.bat**: Main script for mounting network drives from NAS
- **register_nas_mount_task.bat**: Registers task scheduler configuration
- **setup_hourly_nas_task.ps1**: PowerShell script for hourly NAS task setup
- **NasMountTask.xml**: Task scheduler configuration for periodic NAS mounting

### Package Management
- **cinst.bat**: Chocolatey batch installer that reads from packages.txt
- **install_chocolatey.bat**: Chocolatey initial installation
- **install_packages.bat**: Batch package installation
- **packages.txt**: Comprehensive list of development tools organized by category
- **choco update.bat**: Updates all Chocolatey packages (PATH explicitly set for task scheduler)
- **register_choco_update_task.bat** / **remove_choco_update_task.bat**: Task scheduler management

### Development Environment
- **docker_clean.bat**: Comprehensive Docker cleanup (containers, images, system prune)
- **docker-machine start.bat** / **docker-machine start - hv.bat**: Docker machine startup scripts
- **minikube start.bat** / **minikube start - hv.bat**: Kubernetes development environment startup

### uv Cache Management
- **uv_cache_clean.bat**: uv package manager cache cleanup
- **register_uv_cache_clean_task.bat** / **remove_uv_cache_clean_task.bat**: Weekly auto-cleanup task
- Runs weekly on Sundays at 3:00 AM

### Task Scheduler Utilities
- **create_correct_task.bat** / **create_hourly_task.bat** / **create_simple_task.bat**: Task creation templates
- **debug_nas_task.bat**: NAS task debugging

### System Utilities
- **gpedit-enable.bat**: Enables Group Policy Editor
- **robocopy.bat**: File synchronization operations
- **run_as_admin.bat**: Elevate to administrator privileges

## Logging System

All scripts follow a consistent logging pattern:
- Log directory: `C:\work\log`
- Timestamp format: `YYYY-MMDD-HHMMSS`
- Named log files with operation type prefix
- Output redirection: `>> "%LOG%" 2>&1`

## File Patterns

- Comments use `REM` for documentation
- Variables use `SET` with consistent naming (`LOG_DIR`, `LOG`, etc.)
- Error checking with `IF %ERRORLEVEL%` patterns
- Delayed expansion enabled for complex operations

## Dependencies

- Chocolatey package manager
- Docker Desktop
- uv (Python package manager)
- Network access to NAS (IP-based)
- Administrative privileges for scheduled tasks
- Windows Task Scheduler for automation
