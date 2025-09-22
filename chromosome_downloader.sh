#!/bin/bash

# Chromosome 1 Secondary Assemblies Downloader
# This script downloads and processes all secondary assemblies for human chromosome 1
# from UCSC Genome Browser (excluding the main chr1.fa.gz file)

set -e  # Exit on any error

# Color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if required tools are available
check_dependencies() {
    print_status "Checking dependencies..."
    
    local missing_tools=()
    
    # Check for essential tools (always required)
    for tool in gunzip ls wc head; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    # Check for download tools (at least one required)
    local has_curl=false
    local has_wget=false
    
    if command -v curl &> /dev/null; then
        has_curl=true
        print_status "Found curl - will use for downloads"
    fi
    
    if command -v wget &> /dev/null; then
        has_wget=true
        print_status "Found wget - available as backup"
    fi
    
    if [ "$has_curl" = false ] && [ "$has_wget" = false ]; then
        missing_tools+=("curl or wget")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        if [ "$has_curl" = false ] && [ "$has_wget" = false ]; then
            print_error "You need either 'curl' or 'wget' for downloading files."
            print_error "On macOS, curl should be pre-installed. Try: curl --version"
        fi
        exit 1
    fi
    
    print_success "All dependencies are available"
}

# Function to get list of chromosome 1 secondary assemblies
get_chr1_files() {
    print_status "Fetching list of chromosome 1 secondary assemblies..."
    
    local url="https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/"
    local temp_html="temp_listing.html"
    
    # Download the directory listing
    if command -v curl &> /dev/null; then
        curl -s "$url" > "$temp_html"
    elif command -v wget &> /dev/null; then
        wget -q -O "$temp_html" "$url"
    else
        print_error "Neither curl nor wget is available"
        exit 1
    fi
    
    # Extract chromosome 1 files (excluding main chr1.fa.gz)
    # Look for files that start with chr1_ and end with .fa.gz
    local chr1_files=($(grep -o 'chr1_[^"]*\.fa\.gz' "$temp_html" | sort | uniq))
    
    # Clean up temporary file
    rm -f "$temp_html"
    
    if [ ${#chr1_files[@]} -eq 0 ]; then
        print_warning "No secondary chromosome 1 assemblies found"
        return 1
    fi
    
    print_success "Found ${#chr1_files[@]} secondary chromosome 1 assemblies"
    printf '%s\n' "${chr1_files[@]}"
    
    # Return the array through a global variable
    CHR1_FILES=("${chr1_files[@]}")
}

# Function to download files with progress indication
download_file() {
    local url="$1"
    local filename="$2"
    
    print_status "Downloading $filename..."
    
    if command -v curl &> /dev/null; then
        curl -L -o "$filename" "$url" --progress-bar
    elif command -v wget &> /dev/null; then
        wget -O "$filename" "$url" --progress=bar:force
    else
        print_error "Neither curl nor wget is available"
        return 1
    fi
    
    # Verify download
    if [ ! -f "$filename" ] || [ ! -s "$filename" ]; then
        print_error "Failed to download $filename or file is empty"
        return 1
    fi
    
    print_success "Downloaded $filename"
}

# Main execution
main() {
    print_status "Starting Chromosome 1 Secondary Assemblies Download Script"
    echo "=================================================="
    
    # Check dependencies
    check_dependencies
    
    # Step 1: Navigate to home directory
    print_status "Step 1: Navigating to home directory"
    cd "$HOME" || {
        print_error "Failed to navigate to home directory"
        exit 1
    }
    print_success "Now in: $(pwd)"
    
    # Step 2: Create and navigate to Informatics_573 directory
    print_status "Step 2: Creating and navigating to Informatics_573 directory"
    mkdir -p "Informatics_573"
    cd "Informatics_573" || {
        print_error "Failed to navigate to Informatics_573 directory"
        exit 1
    }
    print_success "Now in: $(pwd)"
    
    # Step 3: Get list of chromosome 1 secondary assemblies and download them
    print_status "Step 3: Downloading chromosome 1 secondary assemblies"
    
    # Get the list of files
    if ! get_chr1_files; then
        print_error "Failed to get list of chromosome 1 files"
        exit 1
    fi
    
    # Base URL for downloads
    local base_url="https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/"
    
    # Download each file
    local downloaded_files=()
    for file in "${CHR1_FILES[@]}"; do
        if download_file "${base_url}${file}" "$file"; then
            downloaded_files+=("$file")
        else
            print_warning "Failed to download $file, continuing with others..."
        fi
    done
    
    if [ ${#downloaded_files[@]} -eq 0 ]; then
        print_error "No files were successfully downloaded"
        exit 1
    fi
    
    print_success "Downloaded ${#downloaded_files[@]} files successfully"
    
    # Step 4: Unzip all downloaded files
    print_status "Step 4: Unzipping downloaded files"
    local unzipped_files=()
    for file in "${downloaded_files[@]}"; do
        if [ -f "$file" ]; then
            print_status "Unzipping $file..."
            if gunzip "$file"; then
                # Remove .gz extension to get unzipped filename
                local unzipped_name="${file%.gz}"
                unzipped_files+=("$unzipped_name")
                print_success "Unzipped $file -> $unzipped_name"
            else
                print_warning "Failed to unzip $file"
            fi
        fi
    done
    
    if [ ${#unzipped_files[@]} -eq 0 ]; then
        print_error "No files were successfully unzipped"
        exit 1
    fi
    
    # Step 5: Create data_summary.txt
    print_status "Step 5: Creating data_summary.txt"
    local summary_file="data_summary.txt"
    > "$summary_file"  # Create empty file
    print_success "Created $summary_file"
    
    # Step 6: Append detailed file information
    print_status "Step 6: Adding detailed file information to summary"
    {
        echo "=================================================="
        echo "CHROMOSOME 1 SECONDARY ASSEMBLIES ANALYSIS SUMMARY"
        echo "Generated on: $(date)"
        echo "Working directory: $(pwd)"
        echo "=================================================="
        echo ""
        echo "DETAILED FILE INFORMATION:"
        echo "=========================="
        echo ""
        ls -la "${unzipped_files[@]}" 2>/dev/null || echo "Error listing files"
        echo ""
    } >> "$summary_file"
    
    # Step 7: Append first 10 lines of each assembly
    print_status "Step 7: Adding first 10 lines of each assembly to summary"
    for file in "${unzipped_files[@]}"; do
        if [ -f "$file" ]; then
            {
                echo "=================================================="
                echo "FIRST 10 LINES OF: $file"
                echo "=================================================="
                head -n 10 "$file" 2>/dev/null || echo "Error reading $file"
                echo ""
            } >> "$summary_file"
        fi
    done
    
    # Step 8: Append assembly names and line counts
    print_status "Step 8: Adding assembly names and line counts to summary"
    {
        echo "=================================================="
        echo "ASSEMBLY LINE COUNTS:"
        echo "=================================================="
        echo ""
    } >> "$summary_file"
    
    for file in "${unzipped_files[@]}"; do
        if [ -f "$file" ]; then
            local line_count
            line_count=$(wc -l < "$file" 2>/dev/null || echo "0")
            echo "Assembly: $file - Total lines: $line_count" >> "$summary_file"
        fi
    done
    
    {
        echo ""
        echo "=================================================="
        echo "SUMMARY COMPLETE"
        echo "Total assemblies processed: ${#unzipped_files[@]}"
        echo "Summary generated on: $(date)"
        echo "=================================================="
    } >> "$summary_file"
    
    print_success "All tasks completed successfully!"
    print_status "Summary saved to: $(pwd)/$summary_file"
    print_status "Files processed: ${#unzipped_files[@]}"
    
    echo ""
    echo "Script execution completed. You can find all files in:"
    echo "$(pwd)"
    echo ""
    echo "To view the summary, run: cat $summary_file"
}

# Trap to handle script interruption
cleanup() {
    print_warning "Script interrupted. Cleaning up temporary files..."
    rm -f temp_listing.html
    exit 1
}

trap cleanup INT TERM

# Run main function
main "$@"
