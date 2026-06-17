#!/usr/bin/env bash

# ==============================================================================
# ENTERPRISE BROWSER HARDENING & OPTIMIZATION SCRIPT
# Target Browsers: Mozilla Firefox, Zen Browser, Google Chrome
# Compatibility: Bash 3.2+ (macOS native & Linux environments)
# Execution Constraints: Robust handling under 'set -euo pipefail'
# Privilege Level: Poweruser with sudo elevation for system-wide directories
# ==============================================================================

set -euo pipefail

# Initialize text formatting variables if outputting to an active terminal
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  BLUE='\033[0;34m'
  YELLOW='\033[0;33m'
  NC='\033[0m'
else
  GREEN=''
  BLUE=''
  YELLOW=''
  NC=''
fi

_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
_success() { echo -e "${GREEN}[OK]${NC} $1"; }
_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# 1. OPERATING SYSTEM DETECTION
detect_os() {
  local os_name
  os_name=$(uname -s)
  case "$os_name" in
  Linux*) echo "linux" ;;
  Darwin*) echo "macos" ;;
  *) echo "unknown" ;;
  esac
}

# 2. DYNAMIC RAM CAPACITY CALCULATION
# Calculates the explicit system RAM to scale Gecko parameters proportionally.
calculate_ram_mb() {
  local os=$1
  local total_bytes=0
  local total_mb=0

  if [ "$os" = "macos" ]; then
    # sysctl returns bytes on macOS
    total_bytes=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
    total_mb=$((total_bytes / 1024 / 1024))
  elif [ "$os" = "linux" ]; then
    # Parse MemTotal from /proc/meminfo in kilobytes
    if [ -f /proc/meminfo ]; then
      local total_kb
      total_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo "0")
      total_mb=$((total_kb / 1024))
    fi
  fi

  # Fallback to standard 8GB profile if calculation fails or registers zero
  if [ "$total_mb" -le 0 ]; then
    total_mb=8192
  fi
  echo "$total_mb"
}

# Calculates target threshold. Recommended baseline: 25% of total physical RAM
# down to a minimum floor of 2048MB to avoid loop penalties on restricted devices.
calculate_unload_threshold() {
  local ram_mb=$1
  local threshold=$((ram_mb / 4))
  if [ "$threshold" -lt 2048 ]; then
    threshold=2048
  fi
  echo "$threshold"
}

# 3. GECKO-BASED PATH RESOLUTION (FIREFOX & ZEN)
get_gecko_base_paths() {
  local os=$1
  local browser=$2

  if [ "$os" = "macos" ]; then
    case "$browser" in
    firefox) echo "$HOME/Library/Application Support/Firefox/Profiles" ;;
    zen) echo "$HOME/Library/Application Support/Zen/Profiles" ;;
    esac
  elif [ "$os" = "linux" ]; then
    case "$browser" in
    firefox) echo "$HOME/.mozilla/firefox" ;;
    zen)
      if [ -d "$HOME/.var/app/app.zen_browser.zen/.zen" ]; then
        echo "$HOME/.var/app/app.zen_browser.zen/.zen"
      elif [ -d "$HOME/.config/zen" ]; then
        echo "$HOME/.config/zen"
      else
        echo "$HOME/.zen"
      fi
      ;;
    esac
  fi
}

# 4. MUTATION ENGINE FOR USER.JS CONFIGURATIONS
apply_gecko_preference() {
  local file=$1
  local pref=$2
  local value=$3
  local line="user_pref(\"$pref\", $value);"

  if [ ! -f "$file" ]; then
    touch "$file"
  fi

  # Safe conditional execution bypassing pipefail crash vectors on zero-match lookups
  if grep "(\"$pref\"," "$file" >/dev/null 2>&1; then
    grep -v "(\"$pref\"," "$file" >"$file.tmp" || true
    echo "$line" >>"$file.tmp"
    mv "$file.tmp" "$file"
  else
    echo "$line" >>"$file"
  fi
}

# 5. ORCHESTRATION PIPELINE FOR GECKO BROWSER COMPLIANCE
optimize_gecko_browser() {
  local os=$1
  local browser=$2
  local threshold_mb=$3
  local base_path
  base_path=$(get_gecko_base_paths "$os" "$browser")

  if [ ! -d "$base_path" ]; then
    _info "No profiles directory located for $browser. Skipping."
    return 0
  fi

  _info "Hardening $browser profiles located in: $base_path"

  for profile_dir in "$base_path"/*/; do
    [ -d "$profile_dir" ] || continue

    case "$profile_dir" in
    *Pending\ Pings* | *Crash\ Reports*) continue ;;
    esac

    local user_js_path="${profile_dir}user.js"
    _info " -> Target config update: $(basename "$profile_dir")/user.js"

    # [RAM MANAGEMENT] Adaptive background memory suspension
    apply_gecko_preference "$user_js_path" "browser.tabs.unloadOnLowMemory" "true"
    apply_gecko_preference "$user_js_path" "browser.low_commit_space_threshold_mb" "$threshold_mb"

    # [PROCESS ISOLATION] Constrain heavy multi-process execution (Max 4 content workers)
    apply_gecko_preference "$user_js_path" "dom.ipc.processCount" "4"

    # [BATTERY ECONOMY & PERFORMANCE] Offload compositor cycles to GPU WebRender
    apply_gecko_preference "$user_js_path" "layers.acceleration.force-enabled" "true"
    apply_gecko_preference "$user_js_path" "gfx.webrender.all" "true"

    # [BATTERY ECONOMY] Stripping interface cosmetic overhead cycles
    apply_gecko_preference "$user_js_path" "toolkit.cosmeticAnimations.enabled" "false"
  done
  _success "$browser profiles initialized with performance defaults successfully."
}

# 6. CHROMIUM ENTERPRISE MANAGEMENT SYSTEM (GOOGLE CHROME)
# Deploys standard admin policies. Elevates privileges gracefully via sudo.
apply_chrome_hardening() {
  local os=$1
  _info "Deploying Enterprise Performance Policies for Google Chrome..."

  if [ "$os" = "linux" ]; then
    local policy_dir="/etc/opt/chrome/policies/managed"
    local policy_file="$policy_dir/corporate_performance.json"

    # Inform the poweruser about the upcoming infrastructure alteration
    _warn "Writing system-wide Linux policy file to: $policy_file (requires sudo privilege)"

    # Elevate permissions cleanly using sudo to build the path structure
    sudo mkdir -p "$policy_dir"

    # Write the JSON payload directly through sudo tee to bypass standard redirect limits
    sudo tee "$policy_file" >/dev/null <<EOF
{
  "HighEfficiencyModeEnabled": true,
  "HardwareAccelerationModeEnabled": true,
  "BackgroundModeEnabled": false
}
EOF
    sudo chmod 644 "$policy_file"
    _success "Chrome policies safely committed into standard path: $policy_file"

  elif [ "$os" = "macos" ]; then
    local plist_dir="/Library/Preferences"
    local plist_file="$plist_dir/com.google.Chrome"

    # Inform the poweruser about the upcoming preference manipulation
    _warn "Updating global macOS preferences domain: $plist_file (requires sudo privilege)"

    # Execute macOS defaults writing suite using elevated administrative permissions
    sudo defaults write "$plist_file" HighEfficiencyModeEnabled -bool true
    sudo defaults write "$plist_file" HardwareAccelerationModeEnabled -bool true
    sudo defaults write "$plist_file" BackgroundModeEnabled -bool false

    # Fix file permissions across the targeted plist file using sudo
    sudo chmod 644 "$plist_file.plist"
    _success "System-level defaults dictionary written to: $plist_file.plist"
  fi
}

# ==============================================================================
# MAIN EXECUTION ROUTINE
# ==============================================================================
main() {
  _info "Initializing Unified Enterprise Performance Orchestration Script..."

  local current_os
  current_os=$(detect_os)

  if [ "$current_os" = "unknown" ]; then
    _warn "Unsupported host core kernel detected. Halting execution pipeline."
    exit 1
  fi

  _info "Target System Architecture Match: $current_os"

  # Compute Dynamic RAM Constraints
  local total_ram
  local calculated_threshold
  total_ram=$(calculate_ram_mb "$current_os")
  calculated_threshold=$(calculate_unload_threshold "$total_ram")

  _info "Host Base Memory Registry: ${total_ram}MB RAM"
  _info "Computed Gecko Unload Threshold Target: ${calculated_threshold}MB"

  # Gecko Optimization Pass (User-space profile operations, no sudo required)
  local gecko_targets="firefox zen"
  for browser in $gecko_targets; do
    optimize_gecko_browser "$current_os" "$browser" "$calculated_threshold"
  done

  # Chrome Hardening Pass (System-wide operations, triggers sudo prompt gracefully)
  apply_chrome_hardening "$current_os"

  _success "Unified Configuration Management script successfully applied corporate performance configurations."
}

main
