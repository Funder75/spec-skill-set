#!/usr/bin/env bash
# Copy this checkout's skills/spec into ~/.cursor/skills/spec.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: update-user-spec-skill.sh [--yes] [--dry-run] [source] [destination]

  source       Defaults to <repo>/skills/spec
  destination  Defaults to ~/.cursor/skills/spec

  --yes        Delete destination-only files without prompting
  --dry-run    Show what would change; do not copy or delete
EOF
}

YES=0
DRY_RUN=0
SOURCE_ARG=""
DEST_ARG=""

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --yes|-y)
      YES=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [ -z "$SOURCE_ARG" ]; then
        SOURCE_ARG="$1"
      elif [ -z "$DEST_ARG" ]; then
        DEST_ARG="$1"
      else
        echo "Unexpected argument: $1" >&2
        usage >&2
        exit 2
      fi
      shift
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE="${SOURCE_ARG:-$REPO_ROOT/skills/spec}"
DEST="${DEST_ARG:-$HOME/.cursor/skills/spec}"

if [ ! -f "$SOURCE/SKILL.md" ]; then
  echo "Source is missing SKILL.md: $SOURCE" >&2
  echo "Stopping. Nothing was deleted or copied." >&2
  exit 1
fi
if [ ! -d "$SOURCE/stages" ] || [ ! -d "$SOURCE/templates" ]; then
  echo "Source must contain stages/ and templates/: $SOURCE" >&2
  echo "Stopping. Nothing was deleted or copied." >&2
  exit 1
fi

# Sorted relative paths of regular files under a tree.
list_files() {
  local root="$1"
  if [ ! -d "$root" ]; then
    return 0
  fi
  (cd "$root" && find . -type f ! -name '.DS_Store' | sed 's|^\./||' | sort)
}

SOURCE_LIST="$(list_files "$SOURCE")"
DEST_LIST="$(list_files "$DEST")"
SOURCE_COUNT="$(printf '%s\n' "$SOURCE_LIST" | sed '/^$/d' | wc -l | tr -d ' ')"

ORPHANS=""
ORPHAN_COUNT=0
if [ -n "$DEST_LIST" ]; then
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    if ! printf '%s\n' "$SOURCE_LIST" | grep -Fxq -- "$f"; then
      ORPHANS="${ORPHANS}${f}"$'\n'
      ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
    fi
  done <<EOF
$DEST_LIST
EOF
fi

echo "Source:      $SOURCE"
echo "Destination: $DEST"
echo "Files to copy: $SOURCE_COUNT"

DELETE_ORPHANS=0
if [ "$ORPHAN_COUNT" -gt 0 ]; then
  echo
  echo "Destination-only files (not in source):"
  printf '%s' "$ORPHANS" | sed '/^$/d' | sed 's/^/  /'
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "(dry-run) would ask before deleting these"
  elif [ "$YES" -eq 1 ]; then
    DELETE_ORPHANS=1
    echo "Deleting them (--yes)."
  else
    printf "Delete these %s file(s)? [y/N] " "$ORPHAN_COUNT"
    read -r answer
    case "$answer" in
      y|Y|yes|YES) DELETE_ORPHANS=1 ;;
      *) echo "Leaving destination-only files in place." ;;
    esac
  fi
else
  echo "No destination-only files."
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo
  echo "(dry-run) would copy $SOURCE_COUNT file(s) into $DEST"
  if [ "$DELETE_ORPHANS" -eq 1 ]; then
    echo "(dry-run) would delete $ORPHAN_COUNT destination-only file(s)"
  fi
else
  mkdir -p "$DEST"
  # Copy tree; do not use --delete so orphans stay until confirmed.
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude '.DS_Store' "$SOURCE"/ "$DEST"/
  else
    (cd "$SOURCE" && tar cf - --exclude='.DS_Store' .) | (cd "$DEST" && tar xf -)
  fi

  if [ "$DELETE_ORPHANS" -eq 1 ]; then
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      rm -f "$DEST/$f"
    done <<EOF
$ORPHANS
EOF
    find "$DEST" -type d -empty -delete 2>/dev/null || true
  fi

  # Keep user-skill identity; never rename the skill or rewrite content.
  if ! grep -qE '^name:[[:space:]]*spec[[:space:]]*$' "$DEST/SKILL.md"; then
    echo "Warning: $DEST/SKILL.md frontmatter name is not 'spec'." >&2
    echo "Fix it manually; this script does not rewrite skill content." >&2
  fi
fi

REVISION="unknown"
if git -C "$REPO_ROOT" rev-parse --short HEAD >/dev/null 2>&1; then
  REVISION="$(git -C "$REPO_ROOT" rev-parse --short HEAD)"
fi

echo
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Source revision: $REVISION"
else
  echo "Copied revision: $REVISION"
  echo "Reload the window or open a new Agent chat, then invoke /spec."
fi
