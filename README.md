# Informatics_573
Material BIOINFO 573
# Chromosome 1 Secondary Assemblies Downloader

## Identifying Information

**Programmer:** Venkatesh Pramod Joshi  
**Language:** Bash Shell Script  
**Version:** 3.2.57  
**Date Submitted:** September 21, 2025  
**Script File:** chromosome_downloader.sh

**Description:** This script automatically downloads and processes all secondary assemblies for human chromosome 1 from the University of California Santa Cruz (UCSC) Genome Browser. It excludes the main chr1.fa.gz file and focuses specifically on secondary assemblies (chr1_*.fa.gz files). The script creates a comprehensive analysis report containing file information, sequence data previews, and statistical summaries for bioinformatics research purposes.

## Files Required

This script is self-contained and requires only the following file:

| File Name | Type | Description |
|-----------|------|-------------|
| `chromosome_downloader.sh` | Executable Script | Main bash script containing all functionality for downloading, decompressing, and analyzing chromosome 1 secondary assemblies from UCSC |

**Note:** No additional configuration files, libraries, or data files are required to run this script.

## Required Software and Dependencies

The following software must be installed on your system before running this script:

### Essential Requirements
- **Bash Shell** (version 3.0 or higher) - Command interpreter
- **gunzip** - For decompressing .gz files
- **ls** - For listing file information
- **wc** - For counting lines in files
- **head** - For extracting first lines of files
- **grep** - For pattern matching and file discovery
- **mkdir** - For creating directories

### Download Tools (at least one required)
- **curl** (recommended) - For downloading files from web servers
- **wget** (alternative) - For downloading files from web servers

### System Compatibility
- **macOS:** All required tools are pre-installed
- **Linux:** All required tools are typically pre-installed
- **Windows:** Requires Windows Subsystem for Linux (WSL) or Git Bash

## Installation and Usage Instructions

### For macOS and Linux Systems

1. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/username/repository/main/chromosome_downloader.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x chromosome_downloader.sh
   ```

3. **Run the script:**
   ```bash
   ./chromosome_downloader.sh
   ```

### For Windows Systems

#### Method 1: Using Windows Subsystem for Linux (WSL)

1. **Install WSL if not already installed:**
   ```powershell
   wsl --install
   ```

2. **Restart your computer and open WSL terminal**

3. **Follow the macOS/Linux instructions above within the WSL environment**

#### Method 2: Using Git Bash

1. **Install Git for Windows from:** https://git-scm.com/download/win

2. **Open Git Bash terminal**

3. **Follow the macOS/Linux instructions above within Git Bash**

### Script Execution Details

The script requires no user input and runs completely automatically. It will:

1. Navigate to the user's home directory
2. Create a working directory named "Informatics_573"
3. Download all secondary chromosome 1 assemblies from UCSC
4. Decompress all downloaded files
5. Generate a comprehensive analysis report

**Estimated Runtime:** 15-35 minutes (depending on internet speed)  
**Required Disk Space:** 3-6 GB free space

## Output Files Created

When the script completes successfully, the following files will be created in the `~/Informatics_573/` directory:

### Primary Output File
| File Name | Size | Description |
|-----------|------|-------------|
| `data_summary.txt` | ~50-200 KB | Comprehensive analysis report containing detailed file information, sequence previews, and statistics |

### Downloaded Data Files
| File Pattern | Typical Size | Count | Description |
|--------------|--------------|-------|-------------|
| `chr1_*.fa` | 50-500 KB each | 10-20 files | Uncompressed FASTA files containing chromosome 1 secondary assembly sequences |

### Contents of data_summary.txt

The summary file contains the following sections:

1. **Header Information**
   - Script execution timestamp
   - Working directory location
   - System information

2. **Detailed File Information**
   - File names and sizes
   - File permissions and ownership
   - Creation and modification dates

3. **Sequence Data Previews**
   - First 10 lines of each assembly file
   - FASTA header information

4. **Statistical Summary**
   - Total line count for each assembly
   - Assembly names and identifiers
   - Processing completion status

### Temporary Files

The following temporary files are created during execution but automatically deleted:

- `temp_listing.html` - Temporary file used for parsing UCSC directory listing

## Troubleshooting

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| "Permission denied" error | Run `chmod +x chromosome_downloader.sh` |
| "curl: command not found" | Install curl or ensure wget is available |
| "No space left on device" | Free up at least 6 GB of disk space |
| Download fails | Check internet connection and firewall settings |

### System Requirements Check

Before running the script, verify your system meets the requirements:

```bash
# Check bash version
bash --version

# Check if required tools are available
which curl wget gunzip ls wc head grep mkdir
```

## Support

For questions or issues:
1. Verify all system requirements are met
2. Check internet connectivity
3. Ensure sufficient disk space is available
4. Confirm file permissions are set correctly

---

**Last Updated:** September 21, 2025  
