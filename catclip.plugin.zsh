#!/usr/bin/env zsh
# Catclip - Smart Clipboard Utilities for Zsh
# Cat your files, Clip your workflow 🐱📋
# Following 80-20 Human-in-the-Loop Philosophy

# Plugin metadata
CATCLIP_VERSION="1.0.0"
CATCLIP_LOADED="true"

# Data files for analytics and configuration
CATCLIP_CONFIG="${HOME}/.catclip.config"
CATCLIP_ANALYTICS="${HOME}/.catclip.analytics"
CATCLIP_HISTORY="${HOME}/.catclip.history"
CATCLIP_SESSION="${HOME}/.catclip.session"

# Default configuration following 80-20 philosophy
DEFAULT_TRACK_USAGE="true"          # 80%: Automatic usage tracking
DEFAULT_SHOW_INSIGHTS="true"        # 80%: Automatic insights generation
DEFAULT_CONFIRM_LARGE="true"        # 20%: Human decision for large files
DEFAULT_LARGE_FILE_MB="1"          # Human control threshold
DEFAULT_AUTO_SEPARATORS="true"     # 80%: Smart file separation
DEFAULT_CLIPBOARD_STATS="true"     # 80%: Performance monitoring

# Environment variables for customization (20% human control)
CATCLIP_CLIPBOARD_CMD="${CATCLIP_CLIPBOARD_CMD:-auto}"
CATCLIP_SEPARATOR="${CATCLIP_SEPARATOR:-# === %s ===}"
CATCLIP_CONFIRM_LARGE="${CATCLIP_CONFIRM_LARGE:-$DEFAULT_CONFIRM_LARGE}"
CATCLIP_LARGE_FILE_MB="${CATCLIP_LARGE_FILE_MB:-$DEFAULT_LARGE_FILE_MB}"

# Initialize data files
[[ ! -f "$CATCLIP_CONFIG" ]] && touch "$CATCLIP_CONFIG"
[[ ! -f "$CATCLIP_ANALYTICS" ]] && touch "$CATCLIP_ANALYTICS"
[[ ! -f "$CATCLIP_HISTORY" ]] && touch "$CATCLIP_HISTORY"
[[ ! -f "$CATCLIP_SESSION" ]] && echo "$(date +%Y-%m-%d)" > "$CATCLIP_SESSION"

# Load configuration
_catclip_load_config() {
    if [[ -f "$CATCLIP_CONFIG" ]]; then
        source "$CATCLIP_CONFIG"
    fi
    
    # Set defaults if not configured
    CATCLIP_TRACK_USAGE="${CATCLIP_TRACK_USAGE:-$DEFAULT_TRACK_USAGE}"
    CATCLIP_SHOW_INSIGHTS="${CATCLIP_SHOW_INSIGHTS:-$DEFAULT_SHOW_INSIGHTS}"
    CATCLIP_AUTO_SEPARATORS="${CATCLIP_AUTO_SEPARATORS:-$DEFAULT_AUTO_SEPARATORS}"
    CATCLIP_CLIPBOARD_STATS="${CATCLIP_CLIPBOARD_STATS:-$DEFAULT_CLIPBOARD_STATS}"
}

# 80%: Automatic clipboard utility detection
_catclip_detect_clipboard() {
    local start_time=$(date +%s.%N)
    
    if [[ "$CATCLIP_CLIPBOARD_CMD" != "auto" ]]; then
        echo "$CATCLIP_CLIPBOARD_CMD"
        return 0
    fi
    
    if command -v xclip >/dev/null 2>&1; then
        echo "xclip"
    elif command -v xsel >/dev/null 2>&1; then
        echo "xsel"
    elif command -v wl-copy >/dev/null 2>&1; then
        echo "wl-copy"
    else
        echo "none"
        return 1
    fi
    
    # 80%: Track performance for optimization insights
    if [[ "$CATCLIP_CLIPBOARD_STATS" == "true" ]]; then
        local end_time=$(date +%s.%N)
        local detection_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "clipboard_detection" "$detection_time"
    fi
}

# Helper function for clipboard copying operations
_clip_copy() {
    local clipboard_util=$(_catclip_detect_clipboard)
    local start_time=$(date +%s.%N)
    
    case "$clipboard_util" in
        "xclip")
            xclip -selection clipboard
            local result=$?
            ;;
        "xsel")
            xsel --clipboard --input
            local result=$?
            ;;
        "wl-copy")
            wl-copy
            local result=$?
            ;;
        "none")
            echo "Error: No clipboard utility found. Please install one of:"
            echo "  - xclip: sudo apt install xclip"
            echo "  - xsel: sudo apt install xsel" 
            echo "  - wl-clipboard: sudo apt install wl-clipboard"
            return 1
            ;;
    esac
    
    # 80%: Log performance metrics
    if [[ "$CATCLIP_CLIPBOARD_STATS" == "true" ]] && [[ $result -eq 0 ]]; then
        local end_time=$(date +%s.%N)
        local copy_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "clipboard_copy" "$copy_time" "$clipboard_util"
    fi
    
    return $result
}

# Helper function for clipboard reading operations
_clip_paste() {
    local clipboard_util=$(_catclip_detect_clipboard)
    
    case "$clipboard_util" in
        "xclip")
            xclip -selection clipboard -o
            ;;
        "xsel")
            xsel --clipboard --output
            ;;
        "wl-copy")
            wl-paste
            ;;
        "none")
            echo "Error: No clipboard utility found for reading clipboard"
            return 1
            ;;
    esac
}

# 80%: Automatic usage tracking and analytics
_catclip_track_usage() {
    if [[ "$CATCLIP_TRACK_USAGE" != "true" ]]; then
        return 0
    fi
    
    local operation="$1"
    local file_count="$2"
    local file_size="$3"
    local file_types="$4"
    local timestamp=$(date +%s)
    local date_str=$(date +%Y-%m-%d)
    local hour=$(date +%H)
    
    # Log to analytics file
    echo "${timestamp}|${date_str}|${hour}|${operation}|${file_count}|${file_size}|${file_types}" >> "$CATCLIP_ANALYTICS"
    
    # Log to history file (last 100 operations)
    echo "${timestamp}|${operation}|${file_count}|${file_size}|${file_types}" >> "$CATCLIP_HISTORY"
    tail -n 100 "$CATCLIP_HISTORY" > "${CATCLIP_HISTORY}.tmp" && mv "${CATCLIP_HISTORY}.tmp" "$CATCLIP_HISTORY"
}

# 80%: Performance logging for optimization insights
_catclip_log_performance() {
    local operation="$1"
    local duration="$2"
    local tool="$3"
    local timestamp=$(date +%s)
    
    echo "${timestamp}|${operation}|${duration}|${tool}" >> "${CATCLIP_ANALYTICS}.perf"
}

# 80%: Smart file type detection
_catclip_detect_file_type() {
    local filename="$1"
    local extension="${filename##*.}"
    
    case "$extension" in
        py|python) echo "python" ;;
        js|javascript) echo "javascript" ;;
        json) echo "json" ;;
        yaml|yml) echo "yaml" ;;
        md|markdown) echo "markdown" ;;
        txt|text) echo "text" ;;
        sh|bash|zsh) echo "shell" ;;
        html|htm) echo "html" ;;
        css) echo "css" ;;
        xml) echo "xml" ;;
        conf|config|cfg) echo "config" ;;
        log) echo "log" ;;
        *) echo "other" ;;
    esac
}

# 80%: Automatic file size checking with human control for large files
_catclip_check_file_size() {
    local file="$1"
    local size_bytes=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
    local size_mb=$(echo "scale=2; $size_bytes / 1024 / 1024" | bc 2>/dev/null || echo "0")
    local threshold_mb=$(echo "$CATCLIP_LARGE_FILE_MB" | bc 2>/dev/null || echo "1")
    
    if (( $(echo "$size_mb > $threshold_mb" | bc -l 2>/dev/null || echo "0") )); then
        if [[ "$CATCLIP_CONFIRM_LARGE" == "true" ]]; then
            echo "⚠️  Large file detected: '$file' (${size_mb}MB)"
            echo -n "Continue copying? (y/N): "
            read -r confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                echo "📋 Operation cancelled"
                return 1
            fi
        fi
    fi
    
    echo "$size_bytes"
    return 0
}

# Cat file contents to clipboard (supports multiple files)
catclip() {
    local start_time=$(date +%s.%N)
    
    # Handle special flags (20% human control)
    case "$1" in
        --help|-h)
            echo "Usage: catclip [options] <filename> [filename2] [filename3...]"
            echo ""
            echo "Options:"
            echo "  --help, -h     Show this help message"
            echo "  --insights     Show usage analytics and insights"
            echo "  --stats        Show clipboard statistics"
            echo "  --config       Show/modify configuration"
            echo ""
            echo "Examples:"
            echo "  catclip file.txt                  # Copy single file"
            echo "  catclip *.py                      # Copy all Python files"
            echo "  catclip file1.txt file2.txt       # Copy multiple files"
            echo ""
            echo "Part of the 80-20 Human-in-the-Loop philosophy:"
            echo "  80% - Automatic clipboard detection and file handling"
            echo "  20% - Your conscious choices about what to copy"
            return 0
            ;;
        --insights)
            _catclip_show_insights
            return 0
            ;;
        --stats)
            _catclip_show_stats
            return 0
            ;;
        --config)
            _catclip_show_config
            return 0
            ;;
    esac
    
    if [ $# -eq 0 ]; then
        echo "Usage: catclip <filename> [filename2] [filename3...]"
        echo "  Copy single or multiple file contents to clipboard"
        echo "  Use 'catclip --help' for more options"
        return 1
    fi
    
    # Check all files exist first (80% - automatic validation)
    local total_size=0
    local file_types=()
    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "❌ Error: File '$file' not found"
            return 1
        fi
        
        # Check file size with human confirmation for large files
        local file_size=$(_catclip_check_file_size "$file")
        if [[ $? -ne 0 ]]; then
            return 1
        fi
        total_size=$((total_size + file_size))
        
        # Detect file type for analytics
        local file_type=$(_catclip_detect_file_type "$file")
        file_types+=("$file_type")
    done
    
    # 80%: Smart content preparation
    local content=""
    if [ $# -eq 1 ]; then
        # Single file - direct copy
        content=$(cat "$1")
    else
        # Multiple files - smart separators
        if [[ "$CATCLIP_AUTO_SEPARATORS" == "true" ]]; then
            local temp_content=""
            for file in "$@"; do
                if [[ -n "$temp_content" ]]; then
                    temp_content+="\n\n"
                fi
                temp_content+=$(printf "$CATCLIP_SEPARATOR" "$(basename "$file")")
                temp_content+="\n"
                temp_content+=$(cat "$file")
            done
            content="$temp_content"
        else
            content=$(cat "$@")
        fi
    fi
    
    # Copy to clipboard
    echo "$content" | _clip_copy
    if [[ $? -eq 0 ]]; then
        local clipboard_util=$(_catclip_detect_clipboard)
        if [ $# -eq 1 ]; then
            echo "✅ Contents of '$1' copied to clipboard using $clipboard_util"
        else
            echo "✅ Contents of $# files copied to clipboard using $clipboard_util: $*"
        fi
        
        # 80%: Track usage analytics
        local file_types_str=$(IFS=','; echo "${file_types[*]}")
        _catclip_track_usage "catclip" "$#" "$total_size" "$file_types_str"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "catclip_operation" "$operation_time" "$clipboard_util"
    else
        echo "❌ Failed to copy to clipboard"
        return 1
    fi
}

# Cat file contents with line numbers to clipboard
catclipl() {
    local start_time=$(date +%s.%N)
    
    if [ $# -eq 0 ]; then
        echo "Usage: catclipl <filename>"
        echo "  Copy file contents with line numbers to clipboard"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "❌ Error: File '$1' not found"
        return 1
    fi
    
    # Check file size
    local file_size=$(_catclip_check_file_size "$1")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    cat -n "$1" | _clip_copy
    if [[ $? -eq 0 ]]; then
        local clipboard_util=$(_catclip_detect_clipboard)
        echo "✅ Contents of '$1' with line numbers copied to clipboard using $clipboard_util"
        
        # Track usage
        local file_type=$(_catclip_detect_file_type "$1")
        _catclip_track_usage "catclipl" "1" "$file_size" "$file_type"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "catclipl_operation" "$operation_time"
    else
        echo "❌ Failed to copy to clipboard"
        return 1
    fi
}

# Cat file contents to clipboard AND show on screen
catclips() {
    local start_time=$(date +%s.%N)
    
    if [ $# -eq 0 ]; then
        echo "Usage: catclips <filename>"
        echo "  Show file contents on screen AND copy to clipboard"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "❌ Error: File '$1' not found"
        return 1
    fi
    
    # Check file size
    local file_size=$(_catclip_check_file_size "$1")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    # Use tee to both display and copy
    cat "$1" | tee >(_clip_copy >/dev/null)
    if [[ $? -eq 0 ]]; then
        local clipboard_util=$(_catclip_detect_clipboard)
        echo "\n✅ Contents of '$1' copied to clipboard using $clipboard_util"
        
        # Track usage
        local file_type=$(_catclip_detect_file_type "$1")
        _catclip_track_usage "catclips" "1" "$file_size" "$file_type"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "catclips_operation" "$operation_time"
    else
        echo "❌ Failed to copy to clipboard"
        return 1
    fi
}

# Cat specific line range to clipboard
catclipn() {
    local start_time=$(date +%s.%N)
    
    if [ $# -ne 3 ]; then
        echo "Usage: catclipn <filename> <start_line> <end_line>"
        echo "  Copy lines from start_line to end_line to clipboard"
        echo "  Example: catclipn myfile.py 10 20"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "❌ Error: File '$1' not found"
        return 1
    fi
    
    if ! [[ "$2" =~ ^[0-9]+$ ]] || ! [[ "$3" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: Line numbers must be positive integers"
        return 1
    fi
    
    if [ "$2" -gt "$3" ]; then
        echo "❌ Error: Start line ($2) cannot be greater than end line ($3)"
        return 1
    fi
    
    # Check total file size for analytics
    local file_size=$(_catclip_check_file_size "$1")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    sed -n "${2},${3}p" "$1" | _clip_copy
    if [[ $? -eq 0 ]]; then
        local clipboard_util=$(_catclip_detect_clipboard)
        echo "✅ Lines $2-$3 from '$1' copied to clipboard using $clipboard_util"
        
        # Track usage (partial file)
        local file_type=$(_catclip_detect_file_type "$1")
        local line_count=$((3 - 2 + 1))
        _catclip_track_usage "catclipn" "1" "$file_size" "$file_type"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "catclipn_operation" "$operation_time"
    else
        echo "❌ Failed to copy to clipboard"
        return 1
    fi
}

# Copy current directory path to clipboard
pwdclip() {
    local start_time=$(date +%s.%N)
    local current_path=$(pwd)
    
    echo "$current_path" | _clip_copy
    if [[ $? -eq 0 ]]; then
        local clipboard_util=$(_catclip_detect_clipboard)
        echo "✅ Current directory path copied to clipboard using $clipboard_util: $current_path"
        
        # Track usage
        local path_length=${#current_path}
        _catclip_track_usage "pwdclip" "1" "$path_length" "path"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "pwdclip_operation" "$operation_time"
    else
        echo "❌ Failed to copy to clipboard"
        return 1
    fi
}

# Copy directory listing to clipboard
lsclip() {
    local start_time=$(date +%s.%N)
    
    if [ $# -eq 0 ]; then
        ls | _clip_copy
        local result=$?
        local listing_type="current_dir"
    else
        ls "$@" | _clip_copy
        local result=$?
        local listing_type="custom"
    fi
    
    if [[ $result -eq 0 ]]; then
        local clipboard_util=$(_catclip_detect_clipboard)
        if [ $# -eq 0 ]; then
            echo "✅ Directory listing copied to clipboard using $clipboard_util"
        else
            echo "✅ Directory listing (ls $*) copied to clipboard using $clipboard_util"
        fi
        
        # Track usage
        local content_length=$(ls "$@" 2>/dev/null | wc -c)
        _catclip_track_usage "lsclip" "1" "$content_length" "$listing_type"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "lsclip_operation" "$operation_time"
    else
        echo "❌ Failed to copy to clipboard"
        return 1
    fi
}

# Show current clipboard contents with enhanced stats
clipshow() {
    local start_time=$(date +%s.%N)
    
    echo "📋 Current clipboard contents:"
    echo "────────────────────────────────────────────────────────"
    local content=$(_clip_paste)
    if [[ $? -eq 0 ]]; then
        echo "$content"
        echo "────────────────────────────────────────────────────────"
        
        # Enhanced stats (80% - automatic analysis)
        local lines=$(echo "$content" | wc -l)
        local words=$(echo "$content" | wc -w)
        local chars=$(echo "$content" | wc -c)
        local clipboard_util=$(_catclip_detect_clipboard)
        
        echo "📊 Clipboard Stats:"
        echo "   📄 Content: $lines lines, $words words, $chars characters"
        echo "   🔧 Tool: $clipboard_util"
        echo "   🕐 Retrieved: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # Track usage
        _catclip_track_usage "clipshow" "1" "$chars" "clipboard_view"
        
        # Performance tracking
        local end_time=$(date +%s.%N)
        local operation_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        _catclip_log_performance "clipshow_operation" "$operation_time"
    else
        echo "❌ Failed to read clipboard"
        return 1
    fi
}

# 80%: Automatic insights generation
_catclip_show_insights() {
    if [[ ! -f "$CATCLIP_ANALYTICS" ]] || [[ ! -s "$CATCLIP_ANALYTICS" ]]; then
        echo "📊 No usage data available yet. Use catclip commands to generate insights!"
        return 0
    fi
    
    echo "📊 Catclip Usage Insights - 80-20 Human-in-the-Loop Analytics"
    echo "════════════════════════════════════════════════════════════════"
    
    local today=$(date +%Y-%m-%d)
    local total_operations=$(wc -l < "$CATCLIP_ANALYTICS" 2>/dev/null || echo "0")
    local today_operations=$(grep "^[^|]*|$today|" "$CATCLIP_ANALYTICS" 2>/dev/null | wc -l || echo "0")
    
    echo ""
    echo "📋 Overall Activity:"
    echo "   • Total operations: $total_operations"
    echo "   • Today's operations: $today_operations"
    
    # File type analysis
    echo ""
    echo "📁 File Types (Last 100 operations):"
    if [[ -f "$CATCLIP_HISTORY" ]]; then
        tail -n 100 "$CATCLIP_HISTORY" | cut -d'|' -f5 | tr ',' '\n' | sort | uniq -c | sort -nr | head -5 | while read count type; do
            local percentage=$(echo "scale=1; $count * 100 / 100" | bc 2>/dev/null || echo "0")
            echo "   • $type: $count operations (${percentage}%)"
        done
    fi
    
    # Peak usage hours
    echo ""
    echo "🕐 Peak Usage Hours (Today):"
    if [[ -f "$CATCLIP_ANALYTICS" ]]; then
        grep "^[^|]*|$today|" "$CATCLIP_ANALYTICS" 2>/dev/null | cut -d'|' -f3 | sort | uniq -c | sort -nr | head -3 | while read count hour; do
            echo "   • ${hour}:00 - ${count} operations"
        done
    fi
    
    # Performance insights
    if [[ -f "${CATCLIP_ANALYTICS}.perf" ]]; then
        echo ""
        echo "⚡ Performance Insights:"
        local avg_time=$(awk -F'|' '{sum+=$3; count++} END {if(count>0) printf "%.3f", sum/count; else print "0"}' "${CATCLIP_ANALYTICS}.perf" 2>/dev/null || echo "0")
        echo "   • Average operation time: ${avg_time}s"
        
        local clipboard_tool=$(tail -n 50 "${CATCLIP_ANALYTICS}.perf" | cut -d'|' -f4 | grep -v "^$" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}' || echo "unknown")
        echo "   • Primary clipboard tool: $clipboard_tool"
    fi
    
    echo ""
    echo "💡 80-20 Philosophy in Action:"
    echo "   🤖 80% Computer: Automatic tracking, performance monitoring, smart detection"
    echo "   🧠 20% Human: Your conscious choices about what files to copy and when"
    echo ""
    echo "Use 'catclip --config' to customize your experience"
}

# Show performance and clipboard statistics
_catclip_show_stats() {
    echo "📈 Catclip Performance Statistics"
    echo "════════════════════════════════"
    
    local clipboard_util=$(_catclip_detect_clipboard)
    echo ""
    echo "🔧 Current Configuration:"
    echo "   • Clipboard tool: $clipboard_util"
    echo "   • Large file threshold: ${CATCLIP_LARGE_FILE_MB}MB"
    echo "   • Usage tracking: $CATCLIP_TRACK_USAGE"
    echo "   • Auto separators: $CATCLIP_AUTO_SEPARATORS"
    
    if [[ -f "${CATCLIP_ANALYTICS}.perf" ]]; then
        echo ""
        echo "⚡ Performance Metrics:"
        local operations=$(wc -l < "${CATCLIP_ANALYTICS}.perf" 2>/dev/null || echo "0")
        echo "   • Total measured operations: $operations"
        
        if [[ $operations -gt 0 ]]; then
            local avg_time=$(awk -F'|' '{sum+=$3; count++} END {if(count>0) printf "%.4f", sum/count; else print "0"}' "${CATCLIP_ANALYTICS}.perf")
            local max_time=$(awk -F'|' 'BEGIN{max=0} {if($3>max) max=$3} END{printf "%.4f", max}' "${CATCLIP_ANALYTICS}.perf")
            local min_time=$(awk -F'|' 'BEGIN{min=999} {if($3<min) min=$3} END{printf "%.4f", min}' "${CATCLIP_ANALYTICS}.perf")
            
            echo "   • Average operation time: ${avg_time}s"
            echo "   • Fastest operation: ${min_time}s"
            echo "   • Slowest operation: ${max_time}s"
        fi
    fi
    
    # Current clipboard status
    echo ""
    echo "📋 Current Clipboard Status:"
    local content=$(_clip_paste 2>/dev/null)
    if [[ $? -eq 0 ]] && [[ -n "$content" ]]; then
        local lines=$(echo "$content" | wc -l)
        local chars=$(echo "$content" | wc -c)
        echo "   • Content available: $lines lines, $chars characters"
        echo "   • Last updated: $(stat -c %y /tmp/.clipboard 2>/dev/null || echo 'Unknown')"
    else
        echo "   • Status: Empty or unavailable"
    fi
}

# Configuration interface (20% - human control)
_catclip_show_config() {
    echo "⚙️  Catclip Configuration - 20% Human Control Zone"
    echo "═══════════════════════════════════════════════════════"
    
    _catclip_load_config
    
    echo ""
    echo "Current Settings:"
    echo "  • Usage tracking: $CATCLIP_TRACK_USAGE"
    echo "  • Show insights: $CATCLIP_SHOW_INSIGHTS" 
    echo "  • Auto separators: $CATCLIP_AUTO_SEPARATORS"
    echo "  • Confirm large files: $CATCLIP_CONFIRM_LARGE"
    echo "  • Large file threshold: ${CATCLIP_LARGE_FILE_MB}MB"
    echo "  • Clipboard stats: $CATCLIP_CLIPBOARD_STATS"
    echo ""
    
    echo "🎛️  Want to modify settings? Edit: $CATCLIP_CONFIG"
    echo ""
    echo "Example configuration:"
    cat << 'EOF'
CATCLIP_TRACK_USAGE="true"          # Track usage patterns
CATCLIP_SHOW_INSIGHTS="true"        # Show analytics
CATCLIP_AUTO_SEPARATORS="true"      # Smart file separation
CATCLIP_CONFIRM_LARGE="true"        # Ask before copying large files
CATCLIP_LARGE_FILE_MB="1"           # Large file threshold in MB
CATCLIP_CLIPBOARD_STATS="true"      # Performance monitoring

# Custom clipboard utility (override auto-detection)
# CATCLIP_CLIPBOARD_CMD="xclip"

# Custom file separator for multiple files
# CATCLIP_SEPARATOR="# === %s ==="
EOF
    
    echo ""
    echo "💡 The 80-20 Philosophy:"
    echo "   🤖 80%: Catclip handles detection, optimization, and insights automatically"
    echo "   🧠 20%: You control what to copy, when to copy, and how it behaves"
}

# Initialize plugin
_catclip_load_config

# Plugin initialization message (shown once per session)
if [[ ! -f "${CATCLIP_SESSION}.init" ]]; then
    echo "🐱 Catclip loaded! - Cat your files, Clip your workflow"
    echo "   Try: catclip --help | catclip --insights | catclip filename.txt"
    touch "${CATCLIP_SESSION}.init"
fi