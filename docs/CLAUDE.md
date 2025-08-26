# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Windows batch scripts for system administration and development environment management. The scripts are designed for Japanese Windows systems and include NAS mounting, Chocolatey package management, Docker operations, and development tool automation.

## Script Architecture

### NAS Mount System
- **nas_mount.bat**: Main script for mounting network drives (X:, Y:, Z:) from AS4002T-A6F7 NAS
- **check_nas_mounts.bat**: Monitoring script that verifies drive availability and auto-remounts if needed
- **setup_nas_check_task.bat**: Creates scheduled task for automated NAS monitoring
- **NasMountTask.xml**: Task scheduler configuration for periodic NAS mounting
- **register_nas_mount_task.bat**: Registers the XML task configuration

### Package Management
- **cinst.bat**: Chocolatey batch installer that reads from packages.txt
- **packages.txt**: Comprehensive list of development tools, browsers, utilities organized by category
- **choco update.bat**: Updates all Chocolatey packages

### Development Environment
- **docker_clean.bat**: Comprehensive Docker cleanup (containers, images, system prune)
- **docker-machine start.bat** / **docker-machine start - hv.bat**: Docker machine startup scripts
- **minikube start.bat** / **minikube start - hv.bat**: Kubernetes development environment startup

### System Utilities
- **gpedit-enable.bat**: Enables Group Policy Editor
- **teams.bat**: Microsoft Teams launcher/configuration
- **robocopy.bat**: File synchronization operations
- **suqit.bat**: Custom utility script

## Logging System

All scripts follow a consistent logging pattern:
- Log directory: `C:\work\log`
- Timestamp format: `YYYY-MMDD-HHMMSS`
- Named log files with operation type prefix
- Status files for monitoring scripts

## Key Features

- **Error handling**: Scripts check for directory existence and create as needed
- **Retry logic**: NAS mounting includes automatic retry via monitoring
- **Credential management**: NAS scripts include embedded credentials for automation
- **Japanese language support**: User messages and comments in Japanese
- **Automated scheduling**: Task scheduler integration for periodic operations

## File Patterns

- Comments use `REM` for documentation
- Variables use `SET` with consistent naming (`LOG_DIR`, `LOG`, etc.)
- Error checking with `IF %ERRORLEVEL%` patterns
- Output redirection to log files with `>> "%LOG%" 2>&1`
- Delayed expansion enabled for complex operations

## Dependencies

- Chocolatey package manager
- Docker Desktop
- Network access to AS4002T-A6F7 NAS (IP-based)
- Administrative privileges for scheduled tasks
- Windows Task Scheduler for automation