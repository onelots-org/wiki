#!/bin/bash

# ─── Configuration ───────────────────────────────────────────
DEVICES=(
  "bonito"
  "sargo"
  "crosshatch"
  "blueline"
  "cheeseburger"
  "scorpio"
  "ibiza"
  "dumpling"
  "kebab"
  "fajita"
  "guacamole" # will be guacamole and guacamoleb so...
  "hotdog" # well same
  "gauguin"
  "veux"
  "stone"
  "crownlte"
  "starlte"
  "star2lte"
  "billie"
  "miatoll"
  "polaris"
  "enchilada"
  "b1c1"
  "b4s4"
)

FOLDERS=(
    "../_data/devices"
    "../images/devices"
    "../pages/build"
    "../pages/info"
    "../pages/install"
    "../pages/update"
    "../pages/upgrade"
    "../pages/fw_update"
)
# ─────────────────────────────────────────────────────────────

DRY_RUN=false
echo $FOLDERS

while [[ $# -gt 0 ]]; do
  case $1 in
    -f) IFS=' ' read -ra FOLDERS <<< "$2"; shift 2;;
    --dry-run) DRY_RUN=true; shift;;
    *) echo "Unknown option: $1"; exit 1;;
  esac
done

matches_device() {
  local filename="$1"
  for device in "${DEVICES[@]}"; do
    if [[ "$filename" == *"$device"* ]]; then
      return 0
    fi
  done
  return 1
}

for folder in "${FOLDERS[@]}"; do
  echo "Scanning: $folder (exists: $([ -d "$folder" ] && echo YES || echo NO))"
  while IFS= read -r -d '' file; do
    filename=$(basename "$file")

    if ! matches_device "$filename"; then
      if $DRY_RUN; then
        echo "[DRY-RUN] Would remove: $file"
      else
        echo "Removing: $file"
        rm -rf "$file"
      fi
    fi
  done < <(find "$folder" -type f \( -name "*.md" -o -name "*.png" -o -name "*.yml" \) -print0)
done
